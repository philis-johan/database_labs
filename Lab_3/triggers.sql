
CREATE OR REPLACE VIEW CourseQueuePositions AS (
    SELECT course, student, position AS place FROM WaitingList
);

DROP FUNCTION IF EXISTS register_student CASCADE;
CREATE FUNCTION register_student() RETURNS trigger AS $register_student$
    BEGIN
        IF (NEW.student, NEW.course) IN (SELECT student, course FROM Registered) THEN
            RAISE EXCEPTION 'Student % already registered to course %.', NEW.student, NEW.course;
        END IF;
        IF (NEW.student, NEW.course) IN (SELECT student, course FROM WaitingList) THEN
            RAISE EXCEPTION 'Student % already in the waiting list for course %.', NEW.student, NEW.course;
        END IF;
        IF ((SELECT prereqCourse FROM Prerequisites WHERE targetCourse = NEW.course) EXCEPT
        (SELECT Taken.course FROM Taken WHERE Taken.student = NEW.student)) IS NOT NULL THEN
            RAISE EXCEPTION 'Student % is missing prerequisites.', NEW.student;
        END IF;
        
        IF (SELECT COUNT(*) AS numStudents FROM Registered WHERE Registered.course = NEW.course) >= 
        (SELECT capacity FROM LimitedCourses WHERE LimitedCourses.code = NEW.course) THEN
            INSERT INTO WaitingList VALUES (NEW.student, NEW.course, 
            (SELECT MAX(position) FROM WaitingList WHERE course = NEW.course) + 1);
            Return NULL;
        END IF;

        INSERT INTO Registered VALUES (NEW.student, NEW.course);
        RETURN NULL; -- must return something
    END;
$register_student$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS register_student ON Registrations;
CREATE TRIGGER register_student INSTEAD OF INSERT ON Registrations
FOR EACH ROW EXECUTE FUNCTION register_student();

--------------------------------------------------
DROP FUNCTION IF EXISTS unregister_student CASCADE;
CREATE FUNCTION unregister_student() RETURNS trigger AS $unregister_student$
    BEGIN
        IF OLD.status = 'registered' THEN
            DELETE FROM Registered WHERE Registered.student = OLD.student AND Registered.course = OLD.course; 
            IF (SELECT COUNT(*) AS numStudents FROM Registered WHERE Registered.course = OLD.course) < 
                (SELECT capacity FROM LimitedCourses WHERE LimitedCourses.code = OLD.course) THEN

                INSERT INTO Registered (SELECT student, course FROM WaitingList 
                WHERE course = OLD.course AND position = 1);
                DELETE FROM WaitingList WHERE course = OLD.course AND position = 1;
                UPDATE WaitingList SET position = position - 1 WHERE course = OLD.course; 


            END IF;        
        END IF;
        IF OLD.status = 'waiting' THEN
            -- UPDATE WaitingList SET position = position - 1 WHERE WaitingList.course = OLD.course 
            -- AND position >= (SELECT WaitingList.position FROM WaitingList WHERE WaitingList.student = OLD.student 
            -- AND WaitingList.course = OLD.course);
            -- DELETE FROM WaitingList WHERE WaitingList.student = OLD.student AND WaitingList.course = OLD.course;


            DROP TABLE IF EXISTS OldPosition;
            CREATE TABLE OldPosition (
                old_position INT PRIMARY KEY
            );
            INSERT INTO OldPosition (SELECT WaitingList.position AS old_position 
            FROM WaitingList WHERE course = OLD.course AND student = OLD.student);
        

            DELETE FROM WaitingList WHERE student = OLD.student AND course = OLD.course;
            UPDATE WaitingList SET position = position - 1 WHERE WaitingList.course = OLD.course 
            AND position > (SELECT old_position FROM OldPosition);
 
        END IF;

        RETURN NULL; -- must return something
    END;
$unregister_student$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS unregister_student ON Registrations;
CREATE TRIGGER unregister_student INSTEAD OF DELETE ON Registrations
FOR EACH ROW EXECUTE FUNCTION unregister_student();

