# database_labs

## Domain description

### Departments and programs

* different departments and programs
* some departments are co-hosts of programs
* department names and abbreviations (shortenings) are UNIQUE
* program names are unique, not necessarily abbreviations

### Programs and branches

* programs have branches
* branch names are unique within a program
* each branch have mandatory courses
* branches also have recommended courses

### Student-program-branch

* a student belongs to exactly one program
* a student belongs to at most one branch withing the program

### Courses

* each course is given by one department
* course code is CHAR(6)
* a course can be taken by a student from any program
* all student get the same amount of credits for passing the same course
* some courses are limited to a certain number of students
* courses are classified into different subjects (math, seminar, research)
* not all courses are classified
* some course have multiple classifications
* database need to allow adding new classifications
* some courses prerequisites

### Registration

* students need to register to courses
* to be allowed to register, prerequisites need to be fulfilled (trigger)
* check it's not a passed course

### Limited courses

* if a limited is full, student is put on a waiting list
* if a slot opens up, the slot is given to the student who waited the longest (FIFO)
* students get a grade when a course is taken

### Admin powers

* admin can override prerequisite requirements and sizre restriction and register a student for a course anyway

### Graduation requirements

* Pass all courses on branch and program
* at least 10 credits from recommendedBranch
* at least 20 credits of mathcourses
* at least 10 credits research courses
* at last one seminar course
