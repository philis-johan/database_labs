
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







