

-- Assert error when a student is already registered 
INSERT INTO Registrations VALUES ('1111111111','CCC111', 'registered');
-- Assert error when a student is already in the waiting list 
INSERT INTO Registrations VALUES ('3333333333','CCC222', 'registered');
-- Assert error when a student missed prerequisites
INSERT INTO Registrations VALUES ('4444444444','CCC111','registered');

-- Assert student is put in the waiting list if the course is full



