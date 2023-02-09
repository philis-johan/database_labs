-- DELETE;

DROP TABLE IF EXISTS Students CASCADE;
CREATE TABLE Students(
    idnr CHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    login TEXT NOT NULL,
    program TEXT NOT NULL
    );

DROP TABLE IF EXISTS Branches CASCADE;
CREATE TABLE Branches(
    name TEXT,
    program TEXT,
    PRIMARY KEY (name, program)
    );


DROP TABLE IF EXISTS Courses CASCADE;
CREATE TABLE Courses(
    code CHAR(6) PRIMARY KEY,
    name TEXT NOT NULL,
    credits FLOAT NOT NULL CHECK (credits >= 0),
    department TEXT NOT NULL
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
    FOREIGN KEY (student) REFERENCES Students(idnr),
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
    PRIMARY KEY (student, course)
);

---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

-- INSERT INTO Branches VALUES ('B1','Prog1');
-- INSERT INTO Branches VALUES ('B2','Prog1');
-- -- INSERT INTO Branches VALUES ('B1','Prog2');

-- INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
-- INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
-- INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
-- INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
-- INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
-- INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');

-- INSERT INTO Courses VALUES ('CCC111','C1',22.5,'Dep1');
-- INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
-- INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
-- INSERT INTO Courses VALUES ('CCC444','C4',60,'Dep1');
-- INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');

-- INSERT INTO LimitedCourses VALUES ('CCC222',1);
-- INSERT INTO LimitedCourses VALUES ('CCC333',2);

