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

    def validate_json(self,data, schema):
        try:
            jsonschema.validate(instance=data, schema=schema)
        except jsonschema.exceptions.ValidationError as err:
            print(err)
            return False
        return True

    def execute_sql(self, cur, query, attributes):
        cur.execute(query, attributes)

    def getInfo(self,student):
      with self.conn.cursor() as cur:
        # Here's a start of the code for this part
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
        
        # FinishedCourses_query = """
        #         SELECT jsonb_build_object(
        #             "finished": [
        #             SELECT jsonb_build_object(
        #             :: TEXT 
        #             FROM F
        #             )
        #             ]
        #         ) :: TEXT
        #         FROM FinishedCourses AS s
        #         WHERE s.student = %s;
        #         """
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
        # cur.execute(sql, (student,))
        query_list = [BasicInformation_query, PathToGraduation_query]
        # self.execute_sql(cur, BasicInformation_query, (student,))
        student_info = dict()
        for query in query_list:
            self.execute_sql(cur, query=query[0], attributes=query[1])
            res = cur.fetchone()
            student_info.update(json.loads(res[0]))
        
        
        if student_info:
            return student_info
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

