
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


CREATE OR REPLACE VIEW Registrations AS(
    (SELECT student, course, 'registered' AS status FROM Registered) UNION
    (SELECT student, course, 'waiting' AS status FROM WaitingList)
);

CREATE OR REPLACE VIEW UnreadMandatory AS (
    SELECT Students.idnr AS student, MandatoryProgram.course FROM Students
    INNER JOIN MandatoryProgram ON Students.program = MandatoryProgram.program
    UNION
    SELECT student, MandatoryBranch.course FROM StudentBranches
    INNER JOIN MandatoryBranch ON StudentBranches.branch = MandatoryBranch.branch
    EXCEPT 
    SELECT student, course FROM PassedCourses
);

-- CREATE OR REPLACE VIEW PathToGraduation AS(
--     (SELECT student, course, 'registered' AS status FROM Registered) UNION
--     (SELECT student, course, 'waiting' AS status FROM WaitingList)
-- );


SELECT Students.idnr, COALESCE(SUM(PassedCourses.credits), 0) AS totalCredits 
FROM PassedCourses RIGHT JOIN Students ON Students.idnr = PassedCourses.student
GROUP BY PassedCourses.student, Students.idnr
;

SELECT Students.idnr, COUNT(*) AS mandatoryLeft 
FROM UnreadMandatory RIGHT JOIN Students ON Students.idnr = UnreadMandatory.student
GROUP BY UnreadMandatory.student, Students.idnr
;


SELECT t1.student, t1.totalCredits, t2.mandatoryLeft FROM
(SELECT Students.idnr as student, COALESCE(SUM(PassedCourses.credits), 0) AS totalCredits 
FROM PassedCourses RIGHT JOIN Students ON Students.idnr = PassedCourses.student
GROUP BY PassedCourses.student, Students.idnr) t1
FULL JOIN
(SELECT Students.idnr AS student, COUNT(*) AS mandatoryLeft 
FROM UnreadMandatory RIGHT JOIN Students ON Students.idnr = UnreadMandatory.student
GROUP BY UnreadMandatory.student, Students.idnr) t2
ON t1.student = t2.student
;
