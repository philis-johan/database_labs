
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
    INNER JOIN MandatoryBranch ON StudentBranches.program = MandatoryBranch.program
    AND StudentBranches.branch = MandatoryBranch.branch
    EXCEPT 
    SELECT student, course FROM PassedCourses
);

-- CREATE OR REPLACE VIEW PathToGraduation AS(
--     (SELECT student, course, 'registered' AS status FROM Registered) UNION
--     (SELECT student, course, 'waiting' AS status FROM WaitingList)
-- );


-- SELECT Students.idnr, COALESCE(SUM(PassedCourses.credits), 0) AS totalCredits 
-- FROM PassedCourses RIGHT JOIN Students ON Students.idnr = PassedCourses.student
-- GROUP BY PassedCourses.student, Students.idnr
-- ;

-- SELECT Students.idnr, COALESCE(COUNT(*), 0) AS mandatoryLeft 
-- FROM UnreadMandatory INNER JOIN Students ON Students.idnr = UnreadMandatory.student
-- GROUP BY UnreadMandatory.student, Students.idnr
-- ;

-- SELECT Students.idnr, UnreadMandatory.course AS mandatoryLeft 
-- FROM UnreadMandatory RIGHT JOIN Students ON Students.idnr = UnreadMandatory.student
-- ;

-- SELECT Students.idnr, COUNT(*) AS mandatoryLeft 
-- FROM UnreadMandatory INNER JOIN Students ON Students.idnr = UnreadMandatory.student
-- GROUP BY UnreadMandatory.student, Students.idnr
-- ;

-- (SELECT Students.idnr as student, COALESCE(SUM(PassedCourses.credits), 0) AS totalCredits 
-- FROM PassedCourses RIGHT JOIN Students ON Students.idnr = PassedCourses.student) t3
-- LEFT JOIN Classified ON Classified.classification = 'math' AND Classified.course = 
-- GROUP BY PassedCourses.student, Students.idnr);

SELECT 
(SELECT PassedCourses.student, PassedCourses.course, Classified.classification FROM PassedCourses
INNER JOIN Classified ON Classified.course = PassedCourses.course AND Classified.classification = 'math') t3
;


SELECT t1.student, t1.totalCredits, COALESCE(t2.mandatoryLeft, 0) FROM
(SELECT Students.idnr as student, COALESCE(SUM(PassedCourses.credits), 0) AS totalCredits 
FROM PassedCourses RIGHT JOIN Students ON Students.idnr = PassedCourses.student
GROUP BY PassedCourses.student, Students.idnr) t1
FULL JOIN
(SELECT Students.idnr AS student, COUNT(*) AS mandatoryLeft 
FROM UnreadMandatory INNER JOIN Students ON Students.idnr = UnreadMandatory.student
GROUP BY UnreadMandatory.student, Students.idnr) t2
ON t1.student = t2.student
FULL JOIN
(SELECT PassedCourses.student, COALESCE(SUM(PassedCourses.credits), 0) AS mathCredits 
FROM Classified WHERE Classified.classification = 'math'
LEFT JOIN PassedCourses ON Classified.course = PassedCourses.course
GROUP BY PassedCourses.student)

;
