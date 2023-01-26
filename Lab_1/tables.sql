-- DELETE;

DROP TABLE IF EXISTS Students CASCADE;
CREATE TABLE Students(
    idnr CHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    login TEXT NOT NULL,
    program TEXT NOT NULL
    );


DROP TABLE IF EXISTS Branches;
CREATE TABLE Branches(
    name TEXT,
    program TEXT,
    PRIMARY KEY (name, program)
    );


DROP TABLE IF EXISTS Courses CASCADE;
CREATE TABLE Courses(
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    credits FLOAT NOT NULL,
    department TEXT NOT NULL
    );


DROP TABLE IF EXISTS LimitedCourses;
CREATE TABLE LimitedCourses(
    code TEXT PRIMARY KEY,
    capacity FLOAT NOT NULL,
    FOREIGN KEY (code) REFERENCES Courses(code)
    );

DROP TABLE IF EXISTS StudentBranches;
CREATE TABLE StudentBranches(
    student TEXT PRIMARY KEY,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program)
    );

DROP TABLE IF EXISTS Classifications;
CREATE TABLE Classifications(
    name TEXT PRIMARY KEY
    );
    
DROP TABLE IF EXISTS Classified;
CREATE TABLE Classified(
    course TEXT NOT NULL,
    classification TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (classification) REFERENCES Classifications(name),
    PRIMARY KEY (course, classification)
    );

DROP TABLE IF EXISTS MandatoryProgram;
CREATE TABLE MandatoryProgram(
    course TEXT NOT NULL,
    program TEXT NOT NULL UNIQUE,
    FOREIGN KEY (course) REFERENCES Courses(code)
    );

DROP TABLE IF EXISTS MandatoryBranch;
CREATE TABLE MandatoryBranch(
    course TEXT NOT NULL,
    branch TEXT NOT NULL -- key?,
    program TEXT NOT NULL -- SECONDARY KEY?,
    FOREIGN KEY (course) REFERENCES Courses(code)
    );


---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

INSERT INTO Branches VALUES ('B1','Prog1');
INSERT INTO Branches VALUES ('B2','Prog1');
-- INSERT INTO Branches VALUES ('B1','Prog2');

INSERT INTO Students VALUES ('1111111111','N1','ls1','Prog1');
INSERT INTO Students VALUES ('2222222222','N2','ls2','Prog1');
INSERT INTO Students VALUES ('3333333333','N3','ls3','Prog2');
INSERT INTO Students VALUES ('4444444444','N4','ls4','Prog1');
INSERT INTO Students VALUES ('5555555555','Nx','ls5','Prog2');
INSERT INTO Students VALUES ('6666666666','Nx','ls6','Prog2');

INSERT INTO Courses VALUES ('CCC111','C1',22.5,'Dep1');
INSERT INTO Courses VALUES ('CCC222','C2',20,'Dep1');
INSERT INTO Courses VALUES ('CCC333','C3',30,'Dep1');
INSERT INTO Courses VALUES ('CCC444','C4',60,'Dep1');
INSERT INTO Courses VALUES ('CCC555','C5',50,'Dep1');

INSERT INTO LimitedCourses VALUES ('CCC222',1);
INSERT INTO LimitedCourses VALUES ('CCC333',2);

