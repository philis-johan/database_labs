-- ----- not a real test
-- DROP TABLE IF EXISTS SerialTest;
-- CREATE TABLE SerialTest (
--     name TEXT,
--     age INT,
--     position SERIAL,
--     PRIMARY KEY (name, age)
-- );

-- INSERT INTO SerialTest VALUES('a', 1);
-- INSERT INTO SerialTest VALUES('a', 2);
-- INSERT INTO SerialTest VALUES('a', 3);
-- INSERT INTO SerialTest VALUES('b', 1);
-- INSERT INTO SerialTest VALUES('b', 2);
-- INSERT INTO SerialTest VALUES('b', 3);

-- -- SELECT * FROM SerialTest;
-- -- \set po SELECT SerialTest.position FROM SerialTest WHERE name = 'a' AND age = 1;
-- DROP MATERIALIZED VIEW IF EXISTS OldPosition;
-- CREATE MATERIALIZED VIEW OldPosition AS
-- SELECT position AS old_position FROM SerialTest WHERE name='b' AND age=1;

-- DELETE FROM SerialTest WHERE name='b' AND age=1;
-- UPDATE SerialTest SET position = position - 1 WHERE position > 
-- (SELECT old_position FROM OldPosition);
