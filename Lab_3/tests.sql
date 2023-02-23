

-- Assert error when a student is already registered 
INSERT INTO Registrations VALUES ('1111111111','CCC111', 'registered');
-- Assert error when a student is already in the waiting list 
INSERT INTO Registrations VALUES ('3333333333','CCC222', 'registered');
-- Assert error when a student missed prerequisites
INSERT INTO Registrations VALUES ('4444444444','CCC111','registered');

-- Assert student is put in the waiting list if the course is full
-- ...

DROP TABLE IF EXISTS SerialTest;
CREATE TABLE SerialTest (
    name TEXT,
    age INT,
    position SERIAL,
    PRIMARY KEY (name, age)
);

INSERT INTO SerialTest VALUES('a', 1);
INSERT INTO SerialTest VALUES('a', 2);
INSERT INTO SerialTest VALUES('a', 3);
INSERT INTO SerialTest VALUES('b', 1);
INSERT INTO SerialTest VALUES('b', 2);
INSERT INTO SerialTest VALUES('b', 3);

-- DELETE FROM SerialTest WHERE name='c';

SELECT * FROM SerialTest;






