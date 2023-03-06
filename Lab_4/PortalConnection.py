import psycopg2
import json
import jsonschema

VALIDATION_SCHEMA_FILE = "information_schema.json"

class PortalConnection:
    def __init__(self):
        self.conn = psycopg2.connect(
            host="localhost",
            database="portal",
            user="postgres",
            password="admin")
        self.conn.autocommit = True

    def load_json(self, file_name):
        with open(file_name) as f:
            return json.load(f)

    def validate_json(self, data: dict, schema: dict):
        jsonschema.validate(instance=data, schema=schema)

    def execute_sql(self, cur, query, attributes):
        cur.execute(query, attributes)

    def getInfo(self,student):
      with self.conn.cursor() as cur:
        
        BasicInformation_query = ("""
            SELECT jsonb_build_object(
                'student', s.idnr,
                'name', s.name,
                'login', s.login,
                'program', s.program,
                'branch', s.branch
            ) :: TEXT
            FROM BasicInformation AS s
            WHERE s.idnr = %s;
            """, (student,))
        

        FinishedCourses_query = ("""
            SELECT COALESCE(
                jsonb_build_object(
                    'finished', (
                        jsonb_agg(
                            jsonb_build_object(
                                'code', c.code,
                                'course', c.name,
                                'credits', f.credits,
                                'grade', f.grade
                            )
                        )
                    )
                ),
                jsonb_build_object(
                    'finished', jsonb_build_array()
                )
            ) :: TEXT
            FROM FinishedCourses AS f
            INNER JOIN Courses AS c
            ON c.code = f.course
            WHERE student = %s
            ;
        """, (student,))
        
        FinishedCourses_query2 = ("""
            SELECT COALESCE(
                jsonb_agg(
                    jsonb_build_object(
                        'code', c.code,
                        'course', c.name,
                        'credits', f.credits,
                        'grade', f.grade
                    )
                ),
                jsonb_build_array()
            ) :: TEXT
            FROM FinishedCourses AS f
            INNER JOIN Courses AS c
            ON c.code = f.course
            WHERE student = %s
            ;
        """, (student,))

        # self.execute_sql(cur, FinishedCourses_query2[0], FinishedCourses_query2[1])
        # print(cur.fetchone())

        Registrations_query = ("""
            SELECT jsonb_build_object(
                'registered', jsonb_agg(
                    jsonb_build_object(
                        'code', c.code,
                        'course', c.name,
                        'status', r.status,
                        'position', w.position
                        )
                    )   
                ) :: TEXT
            FROM Registrations r
            INNER JOIN Courses AS c
            ON c.code = r.course
            LEFT JOIN WaitingList AS w
            ON r.student = w.student AND r.course = w.course
            WHERE r.student = %s
            ;
        """, (student,))
        Registrations_query2 = ("""
            SELECT COALESCE(
                jsonb_agg(
                    jsonb_build_object(
                        'code', c.code,
                        'course', c.name,
                        'status', r.status,
                        'position', w.position
                    )
                ),
                jsonb_build_array()
            ) :: TEXT
            FROM Registrations r
            INNER JOIN Courses AS c
            ON c.code = r.course
            LEFT JOIN WaitingList AS w
            ON r.student = w.student AND r.course = w.course
            WHERE r.student = %s
            ;
        """, (student,))

        PathToGraduation_query = ("""
                SELECT jsonb_build_object(
                    'seminarCourses', s.seminarCourses,
                    'mathCredits', s.mathCredits,
                    'researchCredits', s.researchCredits,
                    'totalCredits', s.totalCredits,
                    'canGraduate', s.qualified
                ) :: TEXT
                FROM PathToGraduation AS s
                WHERE s.student = %s;
                """, (student,))

        # query_list = [BasicInformation_query, FinishedCourses_query2, Registrations_query2, PathToGraduation_query]
        queries = {"BasicInformation": BasicInformation_query, 
                      "FinishedCourses": FinishedCourses_query2, 
                      "Registrations": Registrations_query2, 
                      "PathToGraduation": PathToGraduation_query}
        student_info = dict()
        for query_name, query in queries.items():
            self.execute_sql(cur, query=query[0], attributes=query[1])
            # res = cur.fetchone() if isinstance(cur.fetchone, dict) else {"finished": []}
            data = json.loads(cur.fetchone()[0])
            if query_name == "FinishedCourses":
                info = {'finished': data}
            elif query_name == "Registrations":
                info = {'registered': data}
            else:
                info = data

            # student_info.update(json.loads(res[0]))
            student_info.update(info)
        
        # print(student_info)
        schema = self.load_json(VALIDATION_SCHEMA_FILE)
        self.validate_json(student_info, schema)
        if student_info:
            return json.dumps(student_info)
        else:
            return """{"student":"Not found :("}"""

    def register(self, student, courseCode):
        try:
            with self.conn.cursor() as cur:
                sql = """
                    INSERT INTO Registrations VALUES (
                        %s,
                        %s
                        )
                """
                cur.execute(sql, (student, courseCode))
        except psycopg2.Error as e:
            message = getError(e)
            return '{"success":false, "error": "'+message+'"}'

    def check_registered_or_waiting(self, student, courseCode):
        with self.conn.cursor() as cur:
            sql = """
                SELECT student, course FROM Registrations 
                WHERE student = %s AND course = %s
            """
            cur.execute(sql, (student, courseCode))
            return cur.fetchone() is not None

    def unregister(self, student, courseCode):
        try:
            with self.conn.cursor() as cur:
                if not self.check_registered_or_waiting(student, courseCode):
                    return '{"success":false, "error": "Student not registered or in waiting list."}'
                sql = """
                    DELETE FROM Registrations WHERE 
                        'student' = %s AND
                        'course' = %s
                """
                cur.execute(sql, (student, courseCode))
                return '{"success":true}'
        except psycopg2.Error as e:
            message = getError(e)
            return '{"success":false, "error": "'+message+'"}'

def getError(e):
    message = repr(e)
    message = message.replace("\\n"," ")
    message = message.replace("\"","\\\"")
    return message

