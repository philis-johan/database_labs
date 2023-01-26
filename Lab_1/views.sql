
-- SELECT * FROM Students;
-- SELECT * FROM Branches;
-- SELECT * FROM Courses;
-- SELECT * FROM LimitedCourses;

CREATE OR REPLACE VIEW BasicInformation AS (
    SELECT idnr, name, login, Students.program, branch FROM Students 
    LEFT OUTER JOIN StudentBranches ON Students.idnr = StudentBranches.student
);

CREATE OR REPLACE VIEW FinishedCourses AS (
    SELECT student, course, grade, Courses.credits as credits FROM Taken LEFT OUTER JOIN Courses ON Taken.course = Courses.code
);

CREATE OR REPLACE VIEW PassedCourses AS (
    SELECT student, course, credits FROM FinishedCourses WHERE grade != 'U'
);

-- CREATE OR REPLACE VIEW Registrations AS (
--     SELECT student, course, credits FROM FinishedCourses WHERE grade != 'U'
-- );

-- CREATE OR REPLACE VIEW PassedCourses AS (
--     SELECT student, course, credits FROM FinishedCourses WHERE grade != 'U'
-- );
