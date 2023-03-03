
DROP TABLE IF EXISTS Programs CASCADE;
CREATE TABLE Programs(
    name TEXT,
    abbreviation TEXT NOT NULL,
    PRIMARY KEY (name)
    );

DROP TABLE IF EXISTS Students CASCADE;
CREATE TABLE Students(
    idnr CHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    login TEXT NOT NULL UNIQUE,
    program TEXT NOT NULL,
    FOREIGN KEY (program) REFERENCES Programs(name),
    UNIQUE (idnr, program)
    );

DROP TABLE IF EXISTS Branches CASCADE;
CREATE TABLE Branches(
    name TEXT,
    program TEXT,
    PRIMARY KEY (name, program),
    FOREIGN KEY (program) REFERENCES Programs(name)
    );

DROP TABLE IF EXISTS Departments CASCADE;
CREATE TABLE Departments(
    name TEXT,
    abbreviation TEXT NOT NULL,
    PRIMARY KEY (name)
    );


DROP TABLE IF EXISTS Courses CASCADE;
CREATE TABLE Courses(
    code CHAR(6) PRIMARY KEY,
    name TEXT NOT NULL,
    credits FLOAT NOT NULL CHECK (credits >= 0),
    department TEXT,
    FOREIGN KEY (department) REFERENCES Departments(name)
    );


DROP TABLE IF EXISTS LimitedCourses CASCADE;
CREATE TABLE LimitedCourses(
    code CHAR(6) PRIMARY KEY,
    capacity FLOAT NOT NULL CHECK (capacity >= 0),
    FOREIGN KEY (code) REFERENCES Courses(code)
    );

DROP TABLE IF EXISTS StudentBranches CASCADE;
CREATE TABLE StudentBranches(
    student TEXT PRIMARY KEY,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (student, program) REFERENCES Students(idnr, program),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program)
    );

DROP TABLE IF EXISTS Classifications CASCADE;
CREATE TABLE Classifications(
    name TEXT PRIMARY KEY
    );
    
DROP TABLE IF EXISTS Classified CASCADE;
CREATE TABLE Classified(
    course CHAR(6) NOT NULL,
    classification TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (classification) REFERENCES Classifications(name),
    PRIMARY KEY (course, classification)
    );

DROP TABLE IF EXISTS DepartmentPrograms CASCADE;
CREATE TABLE DepartmentPrograms(
    department TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (department) REFERENCES Departments(name),
    FOREIGN KEY (program) REFERENCES Programs(name),
    PRIMARY KEY (department, program)
    );

DROP TABLE IF EXISTS MandatoryProgram CASCADE;
CREATE TABLE MandatoryProgram(
    course CHAR(6) NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (course, program)
    );

DROP TABLE IF EXISTS MandatoryBranch CASCADE;
CREATE TABLE MandatoryBranch(
    course CHAR(6) NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (course, branch, program)
    );

DROP TABLE IF EXISTS RecommendedBranch CASCADE;
CREATE TABLE RecommendedBranch(
    course CHAR(6) NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (course, branch, program)
    );

DROP TABLE IF EXISTS Registered CASCADE;
CREATE TABLE Registered(
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (student, course)
    );

DROP TABLE IF EXISTS Taken CASCADE;
CREATE TABLE Taken(
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    grade CHAR(1) NOT NULL,
    CONSTRAINT ok_grade CHECK(grade IN ('U','3','4','5')),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (student, course)
);

DROP TABLE IF EXISTS WaitingList CASCADE;
CREATE TABLE WaitingList(
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    position SERIAL NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES LimitedCourses(code),
    PRIMARY KEY (student, course),
    UNIQUE (course, position)
);

DROP TABLE IF EXISTS Prerequisites CASCADE;
CREATE TABLE Prerequisites(
    targetCourse CHAR(6),
    prereqCourse CHAR(6),
    FOREIGN KEY (targetCourse) REFERENCES Courses(code),
    FOREIGN KEY (prereqCourse) REFERENCES Courses(code),
    PRIMARY KEY (targetCourse, prereqCourse)
);

-- ###########################

INSERT INTO Programs VALUES ('Prog1', 'P1');
INSERT INTO Programs VALUES ('Prog2', 'P2');

INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');

INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
INSERT INTO Branches VALUES ('B1','Prog2');

INSERT INTO Departments VALUES ('Dep1','D1');

INSERT INTO Courses VALUES ('CCC111','C1',22.5,'Dep1');
INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
INSERT INTO Courses VALUES ('CCC444','C4',60,'Dep1');
INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');
INSERT INTO Courses VALUES ('CCC666','C5',50,'Dep1');
INSERT INTO Courses VALUES ('CCC777','C5',50,'Dep1');
INSERT INTO Courses VALUES ('CCC999','C1',50,'Dep1');

INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',2);
INSERT INTO LimitedCourses VALUES ('CCC666',2);


INSERT INTO StudentBranches VALUES ('2222222222','B1','Prog1');
INSERT INTO StudentBranches VALUES ('3333333333','B1','Prog2');
INSERT INTO StudentBranches VALUES ('4444444444','B1','Prog1');
INSERT INTO StudentBranches VALUES ('5555555555','B1','Prog2');

INSERT INTO Classifications VALUES ('math');
INSERT INTO Classifications VALUES ('research');
INSERT INTO Classifications VALUES ('seminar');

INSERT INTO Classified VALUES ('CCC333','math');
INSERT INTO Classified VALUES ('CCC444','math');
INSERT INTO Classified VALUES ('CCC444','research');
INSERT INTO Classified VALUES ('CCC444','seminar');

INSERT INTO DepartmentPrograms VALUES('Dep1', 'Prog1');

INSERT INTO MandatoryProgram VALUES ('CCC111','Prog1');

INSERT INTO MandatoryBranch VALUES ('CCC333', 'B1', 'Prog1');
INSERT INTO MandatoryBranch VALUES ('CCC444', 'B1', 'Prog2');

INSERT INTO RecommendedBranch VALUES ('CCC222', 'B1', 'Prog1');
INSERT INTO RecommendedBranch VALUES ('CCC333', 'B1', 'Prog2');

INSERT INTO Registered VALUES ('1111111111','CCC111');
INSERT INTO Registered VALUES ('2222222222','CCC111');
INSERT INTO Registered VALUES ('3333333333','CCC111');
INSERT INTO Registered VALUES ('1111111111','CCC222');
INSERT INTO Registered VALUES ('1111111111','CCC333');
INSERT INTO Registered VALUES ('2222222222','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC222');
INSERT INTO Registered VALUES ('5555555555','CCC333');

INSERT INTO Taken VALUES('4444444444','CCC111','5');
INSERT INTO Taken VALUES('4444444444','CCC222','5');
INSERT INTO Taken VALUES('4444444444','CCC333','5');
INSERT INTO Taken VALUES('4444444444','CCC444','5');
INSERT INTO Taken VALUES('3333333333','CCC999','5');

INSERT INTO Taken VALUES('5555555555','CCC111','5');
INSERT INTO Taken VALUES('5555555555','CCC222','4');
INSERT INTO Taken VALUES('5555555555','CCC444','3');

INSERT INTO Taken VALUES('2222222222','CCC111','U');
INSERT INTO Taken VALUES('2222222222','CCC222','U');
INSERT INTO Taken VALUES('2222222222','CCC444','U');

INSERT INTO WaitingList VALUES('3333333333','CCC222',1);
INSERT INTO WaitingList VALUES('3333333333','CCC333',1);
INSERT INTO WaitingList VALUES('2222222222','CCC333',2);
INSERT INTO WaitingList VALUES('6666666666','CCC333',3);

INSERT INTO Prerequisites VALUES ('CCC111','CCC999');
INSERT INTO Prerequisites VALUES ('CCC777','CCC999');

-- ######################

CREATE OR REPLACE VIEW BasicInformation AS (
    SELECT idnr, name, login, Students.program, branch FROM Students 
    LEFT OUTER JOIN StudentBranches ON Students.idnr = StudentBranches.student
);

CREATE OR REPLACE VIEW FinishedCourses AS (
    SELECT student, course, grade, Courses.credits as credits FROM Taken LEFT OUTER JOIN Courses ON Taken.course = Courses.code
);

DROP VIEW IF EXISTS PassedCourses;
CREATE OR REPLACE VIEW PassedCourses AS (
    SELECT student, course, credits FROM FinishedCourses WHERE grade != 'U'
);

CREATE OR REPLACE VIEW Registrations AS (
    (SELECT student, course, 'registered' AS status FROM Registered) UNION
    (SELECT student, course, 'waiting' AS status FROM WaitingList)
);


DROP VIEW IF EXISTS UnreadMandatory;
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

CREATE OR REPLACE VIEW PathToGraduation AS (
    SELECT t1.student, t1.totalCredits, COALESCE(t2.mandatoryLeft, 0) as mandatoryLeft, t3.mathCredits, t4.researchCredits, 
    COALESCE(t5.seminarCourses, 0) as seminarCourses, COALESCE(t6.qualified, TRUE) as qualified FROM

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

    (SELECT Students.idnr as student, COALESCE(SUM(t72.recommendedCredits), 0) as recommendedCredits 
    FROM Students LEFT JOIN
    (SELECT PassedCourses.student as student, t71.course as course, PassedCourses.credits as recommendedCredits FROM PassedCourses
    INNER JOIN
    (SELECT StudentBranches.student as student, RecommendedBranch.course as course FROM StudentBranches
    INNER JOIN RecommendedBranch 
    ON StudentBranches.program = RecommendedBranch.program AND StudentBranches.branch = RecommendedBranch.branch) t71
    ON PassedCourses.course = t71.course AND PassedCourses.student = t71.student) t72
    ON Students.idnr = t72.student
    GROUP BY Students.idnr, t72.student) t7
    ON t1.student = t7.student
    LEFT JOIN


    (SELECT students.idnr as student, FALSE as qualified FROM Students) t6
    ON t1.student = t6.student AND (t2.mandatoryLeft != 0 OR t3.mathCredits < 20 OR t4.researchCredits < 10 OR t5.seminarCourses = 0
    OR t7.recommendedCredits < 10)
);





