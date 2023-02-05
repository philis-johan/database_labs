
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
    INNER JOIN MandatoryBranch 
    ON StudentBranches.program = MandatoryBranch.program AND StudentBranches.branch = MandatoryBranch.branch
    EXCEPT 
    SELECT student, course FROM PassedCourses
);

-- CREATE OR REPLACE VIEW PathToGraduation AS(
--     (SELECT student, course, 'registered' AS status FROM Registered) UNION
--     (SELECT student, course, 'waiting' AS status FROM WaitingList)
-- );



--- main
SELECT t1.student, t1.totalCredits, COALESCE(t2.mandatoryLeft, 0) as mandatoryLeft, t3.mathCredits, t4.researchCredits, 
COALESCE(t5.seminarCourses, 0) as seminarCourses, COALESCE(t6.qualified, 't') as qualified FROM

(SELECT Students.idnr as student, COALESCE(SUM(PassedCourses.credits), 0) AS totalCredits 
FROM PassedCourses RIGHT JOIN Students ON Students.idnr = PassedCourses.student
GROUP BY PassedCourses.student, Students.idnr) t1
LEFT JOIN

(SELECT Students.idnr AS student, COUNT(*) AS mandatoryLeft 
FROM UnreadMandatory INNER JOIN Students ON Students.idnr = UnreadMandatory.student
GROUP BY UnreadMandatory.student, Students.idnr) t2
ON t1.student = t2.student
LEFT JOIN

(SELECT Students.idnr as student, COALESCE(SUM(t31.mathCredits), 0) AS mathCredits FROM Students
FULL JOIN 
(SELECT PassedCourses.student as student, PassedCourses.course as course, PassedCourses.credits as mathCredits
FROM PassedCourses
INNER JOIN Classified ON Classified.course = PassedCourses.course AND Classified.classification = 'math') t31
ON t31.student = Students.idnr
GROUP BY t31.student, Students.idnr) t3
ON t1.student = t3.student
LEFT JOIN

(SELECT Students.idnr as student, COALESCE(SUM(t41.researchCredits), 0) AS researchCredits FROM Students
FULL JOIN 
(SELECT PassedCourses.student as student, PassedCourses.course as course, PassedCourses.credits as researchCredits
FROM PassedCourses
INNER JOIN Classified ON Classified.course = PassedCourses.course AND Classified.classification = 'research') t41
ON t41.student = Students.idnr
GROUP BY t41.student, Students.idnr) t4
ON t1.student = t4.student
LEFT JOIN

(SELECT Students.idnr as student, Count(*) AS seminarCourses FROM Students
INNER JOIN 
(SELECT PassedCourses.student as student, PassedCourses.course as course, PassedCourses.credits as seminarCourses
FROM PassedCourses
INNER JOIN Classified ON Classified.course = PassedCourses.course AND Classified.classification = 'seminar') t51
ON t51.student = Students.idnr
GROUP BY t51.student, Students.idnr) t5
ON t1.student = t5.student
LEFT JOIN

(SELECT students.idnr as student, 'f' as qualified FROM Students) t6
ON t1.student = t6.student AND (t2.mandatoryLeft != 0 OR t3.mathCredits < 20 OR t4.researchCredits < 10 OR t5.seminarCourses = 0)
;

--- 

-- draft
SELECT PassedCourses.student as student, PassedCourses.course, PassedCourses.credits as recommendedCredits FROM PassedCourses
LEFT JOIN
(SELECT StudentBranches.student as student, RecommendedBranch.course as course FROM StudentBranches
INNER JOIN RecommendedBranch 
ON StudentBranches.program = RecommendedBranch.program AND StudentBranches.branch = RecommendedBranch.branch) t61
ON PassedCourses.course = t61.course
;
