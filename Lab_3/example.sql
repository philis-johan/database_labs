DROP TABLE IF EXISTS emp;
CREATE TABLE emp (
    empname TEXT, 
    salary INTEGER,
    last_date TIMESTAMP,
    last_user TEXT
);

DROP FUNCTION IF EXISTS emp_stamp CASCADE;
CREATE FUNCTION emp_stamp() RETURNS trigger AS $emp_stamp$
    BEGIN
        -- Check that empname and salary are given
        IF NEW.empname IS NULL THEN
            RAISE EXCEPTION 'empname cannot be null';
        END IF;
        IF NEW.salary IS NULL THEN
            RAISE EXCEPTION '% cannot have null salary', NEW.empname;
        END IF;

        -- Who works for us when they must pay for it?
        IF NEW.salary < 0 THEN
            RAISE EXCEPTION '% cannot have negative salary', NEW.empname;
        END IF;

        -- Remember who changed the payroll when
        NEW.last_date := current_timestamp;
        NEW.last_user := current_user;
        RETURN NEW;
    END;
$emp_stamp$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS emp_stamp ON emp;
CREATE TRIGGER emp_stamp BEFORE INSERT OR UPDATE ON emp
FOR EACH ROW EXECUTE FUNCTION emp_stamp();

INSERT INTO emp VALUES('jakob', 40000,'1970-01-01 00:00:01', 'svanken');
INSERT INTO emp VALUES('johan', 30000,'1971-01-01 00:00:01', 'sauna boss');
INSERT INTO emp VALUES('johan2', -30000,'1971-01-01 00:00:01', 'sauna boss');

UPDATE emp SET salary=50000 WHERE empname='johan';