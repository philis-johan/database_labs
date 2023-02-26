-- TEST #1: Register to an unlimited course.
-- EXPECTED OUTCOME: Pass
INSERT INTO Registrations VALUES ('5555555555', 'CCC444', 'registered');

-- TEST #2: Register an already registered student.
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('1111111111','CCC111', 'registered');

-- TEST #3: Register a student already in waiting list.
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('3333333333','CCC222', 'registered');

-- TEST #4: Register a student that misses prerequisites.
-- EXPECTED OUTCOME: Fail
INSERT INTO Registrations VALUES ('4444444444','CCC111','registered');

-- TEST #5: Unregister from an unlimited course.
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE course = 'CCC111' AND student = '1111111111';

-- TEST #6: Unregister from a limited course without a waiting list.
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE course = 'CCC111' AND student = '2222222222';

-- TEST #1: Unregister from a limited course with a waiting list, when the student is registered.
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE course = 'CCC222' AND student = '5555555555';

-- TEST #7: Unregister from a limited course with a waiting list, 
-- when the student is in the middle of the middle of the waiting list.
-- EXPECTED OUTCOME: Pass
DELETE FROM Registrations WHERE course = 'CCC333' AND student = '2222222222';






-- Unregistration test (position needs to be changed also when removing)
SELECT * FROM Registered;
SELECT * FROM WaitingList;
DELETE FROM Registrations WHERE course = 'CCC333' 
AND student = '3333333333'; -- (delete from waitinglist)
DELETE FROM Registrations WHERE course = 'CCC333' 
AND student = '5555555555'; -- (delete from registered)
SELECT * FROM Registered;
SELECT * FROM WaitingList;



----- not a real test
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

-- SELECT * FROM SerialTest;
-- \set po SELECT SerialTest.position FROM SerialTest WHERE name = 'a' AND age = 1;
DROP MATERIALIZED VIEW IF EXISTS OldPosition;
CREATE MATERIALIZED VIEW OldPosition AS
SELECT position AS old_position FROM SerialTest WHERE name='b' AND age=1;

DELETE FROM SerialTest WHERE name='b' AND age=1;
UPDATE SerialTest SET position = position - 1 WHERE position > 
(SELECT old_position FROM OldPosition);









