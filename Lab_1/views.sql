
-- SELECT * FROM Students;
SELECT * FROM Branches;
SELECT * FROM Courses;
SELECT * FROM LimitedCourses;

CREATE OR REPLACE VIEW BasicInformation AS 
(SELECT * FROM Students);

SELECT * FROM BasicInformation