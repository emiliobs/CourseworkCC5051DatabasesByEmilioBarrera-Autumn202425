--CREATE DATABASE IF NOT EXISTS University_Database;

USE University_Database;


DROP TABLE IF EXISTS Department;
DROP TABLE IF EXISTS AcademicStaff;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Module;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS NextOfKin;
DROP TABLE IF EXISTS Teacher;
DROP TABLE IF EXISTS Performance;

SELECT * FROM Department; 

SELECT * FROM AcademicStaff;


SELECT * FROM Course; 

SELECT * FROM Module;

SELECT * FROM Student;

SELECT * FROM Teacher;

SELECT * FROM NextOfKin;

SELECT * FROM Performance;

SELECT * FROM Studies;

SELECT * FROM TaughtBy;


-- Creation of the Tables

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager
FOREIGN KEY (ManagerID)
REFERENCES AcademicStaff(StaffID) ON DELETE SET NULL;

ALTER TABLE AcademicStaff
ADD CONSTRAINT FK_AcademicStaff_Department
FOREIGN KEY (DepartmentID)
REFERENCES Department(DepartmentID) ON DELETE CASCADE;



 -- Create the Department Table
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY, -- Unique identifier for each department
    Name VARCHAR2(100), -- Name of the department
    Phone VARCHAR2(15), -- Department's phone number
    Fax VARCHAR2(15), -- Department's fax number
    Location VARCHAR2(50), -- Location of the department
    ManagerID INT -- Staff ID of the department manager
    CONSTRAINT FK_Department_Manager FOREIGN KEY (ManagerID) 
    REFERENCES AcademicStaff(StaffID) ON DELETE SET NULL -- Ensures valid manager ID; sets to NULL if manager is removed
);

-- Create the AcademicStaff Table
CREATE TABLE AcademicStaff (
    StaffID INT PRIMARY KEY, -- Unique identifier for each staff member
    FirstName VARCHAR2(50), -- Staff's first name
    LastName VARCHAR2(50), -- Staff's last name
    PhoneExtension VARCHAR2(10), -- Staff's phone extension
    OfficeNumber VARCHAR2(10), -- Office number of the staff
    Sex CHAR(1), -- Gender of the staff ('M' or 'F')
    Salary NUMBER(10, 2), -- Staff's salary
    Post VARCHAR2(50), -- Job title of the staff
    Qualifications VARCHAR2(100), -- Staff's qualifications
    Address VARCHAR2(255), -- Residential address
    WorksForDepartmentID INT -- ID of the department the staff works for
    CONSTRAINT FK_AcademicStaff_Department FOREIGN KEY (WorksForDepartmentID) 
    REFERENCES Department(DepartmentID) ON DELETE CASCADE -- Cascades deletion of department to related staff
);




 
-- Create the Course Table
CREATE TABLE Course (
    CourseCode VARCHAR2(10) PRIMARY KEY, -- Unique identifier for each course
    Title VARCHAR2(100), -- Course title
    Duration INT, -- Duration of the course (e.g., in weeks)
    DepartmentID INT, -- Department offering the course
    ManagerID INT, -- Staff ID of the course manager
    CONSTRAINT FK_Course_Department FOREIGN KEY (DepartmentID) 
    REFERENCES Department(DepartmentID) ON DELETE CASCADE, -- Cascades deletion of department to related courses
    CONSTRAINT FK_Course_Manager FOREIGN KEY (ManagerID) 
    REFERENCES AcademicStaff(StaffID) ON DELETE SET NULL -- Nullifies manager ID if manager is removed
);

-- Create the Module Table
CREATE TABLE Module (
    ModuleCode VARCHAR2(10) PRIMARY KEY, -- Unique identifier for each module
    Title VARCHAR2(100), -- Module title
    StartDate DATE, -- Start date of the module
    EndDate DATE, -- End date of the module
    Texts CLOB, -- Text materials or references
    AssessmentScheme VARCHAR2(100), -- Module assessment scheme
    CoordinatorID INT, -- Staff ID of the module coordinator
    CourseCode VARCHAR2(10), -- Course to which the module belongs
    CONSTRAINT FK_Module_Coordinator FOREIGN KEY (CoordinatorID) 
    REFERENCES AcademicStaff(StaffID) ON DELETE SET NULL, -- Nullifies coordinator ID if removed
    CONSTRAINT FK_Module_Course FOREIGN KEY (CourseCode) 
    REFERENCES Course(CourseCode) ON DELETE CASCADE -- Cascades deletion of course to related modules
);

-- Create the Student Table
CREATE TABLE Student (
    MatricNo VARCHAR2(10) PRIMARY KEY, -- Unique identifier for each student
    FirstName VARCHAR2(50), -- Student's first name
    LastName VARCHAR2(50), -- Student's last name
    Address CLOB, -- Residential address
    DOB DATE, -- Date of birth
    Sex CHAR(1), -- Gender of the student ('M' or 'F')
    FinancialLoan NUMBER(10, 2), -- Loan amount for the student
    CourseCode VARCHAR2(10), -- Enrolled course code
    CONSTRAINT FK_Student_Course FOREIGN KEY (CourseCode) 
    REFERENCES Course(CourseCode) ON DELETE CASCADE -- Cascades deletion of course to related students
);


-- Create the NextOfKin Table
CREATE TABLE NextOfKin (
    KinID INT PRIMARY KEY, -- Unique identifier for each next of kin
    Name VARCHAR2(100), -- Name of the next of kin
    Address CLOB, -- Residential address
    Phone VARCHAR2(15), -- Contact number
    Relationship VARCHAR2(50), -- Relationship to the student
    StudentID VARCHAR2(10), -- Related student ID
    CONSTRAINT FK_NextOfKin_Student FOREIGN KEY (StudentID) 
    REFERENCES Student(MatricNo) ON DELETE CASCADE -- Cascades deletion of student to their next of kin
);


-- Create the Teacher Table
CREATE TABLE Teacher (
    StaffID INT, -- Staff ID teaching the module
    ModuleCode VARCHAR2(10), -- Module being taught
    HoursPerWeek INT, -- Hours allocated per week
    PRIMARY KEY (StaffID, ModuleCode), -- Composite primary key
    CONSTRAINT FK_Teacher_Staff FOREIGN KEY (StaffID) 
    REFERENCES AcademicStaff(StaffID) ON DELETE CASCADE, -- Cascades deletion of staff to related teaching assignments
    CONSTRAINT FK_Teacher_Module FOREIGN KEY (ModuleCode) 
    REFERENCES Module(ModuleCode) ON DELETE CASCADE -- Cascades deletion of module to related teaching assignments
);


-- Create the Performance Table
CREATE TABLE Performance (
    StudentID VARCHAR2(10), -- Student ID
    ModuleCode VARCHAR2(10), -- Module ID
    PassOrFail CHAR(1), -- Result ('P' for pass, 'F' for fail)
    PRIMARY KEY (StudentID, ModuleCode), -- Composite primary key
    CONSTRAINT FK_Performance_Student FOREIGN KEY (StudentID) 
    REFERENCES Student(MatricNo) ON DELETE CASCADE, -- Cascades deletion of student to their performance records
    CONSTRAINT FK_Performance_Module FOREIGN KEY (ModuleCode) 
    REFERENCES Module(ModuleCode) ON DELETE CASCADE -- Cascades deletion of module to related performance records
);


-- Create the Performance Table

CREATE TABLE Enrollment (
    EnrollmentID INT PRIMARY KEY, -- Unique ID for each enrollment record
    StudentID VARCHAR(10) NOT NULL,             -- Foreign key to Student table
    CourseCode VARCHAR(10) NOT NULL,            -- Foreign key to Course table
    EnrollmentDate DATE NOT NULL,               -- Date of enrollment
    Grade CHAR(2),                              -- Optional grade for the course
    FOREIGN KEY (StudentID) REFERENCES Student(MatricNo) ON DELETE CASCADE,
    FOREIGN KEY (CourseCode) REFERENCES Course(CourseCode) ON DELETE CASCADE
);

SELECT * FROM Enrollment;

-- Create the TaughtBy Table
CREATE TABLE TaughtBy (
    StaffID INT, -- Staff ID of the academic staff teaching the module
    ModuleCode VARCHAR2(10), -- Code of the module being taught
    PRIMARY KEY (StaffID, ModuleCode), -- Composite primary key to uniquely identify each teaching assignment
    CONSTRAINT FK_TaughtBy_Staff FOREIGN KEY (StaffID) 
    REFERENCES AcademicStaff(StaffID) ON DELETE CASCADE, -- Cascades deletion of staff to related TaughtBy records
    CONSTRAINT FK_TaughtBy_Module FOREIGN KEY (ModuleCode) 
    REFERENCES Module(ModuleCode) ON DELETE CASCADE -- Cascades deletion of module to related TaughtBy records
);

-- Create the Studies Table
CREATE TABLE Studies (
    StudentID VARCHAR2(10), -- Student ID
    ModuleCode VARCHAR2(10,) -- Module ID
    PRIMARY KEY (StudentID, ModuleCode), -- Composite primary key
    CONSTRAINT FK_Studies_Student FOREIGN KEY (StudentID) 
    REFERENCES Student(MatricNo) ON DELETE CASCADE, -- Cascades deletion of student to their studies records
    CONSTRAINT FK_Studies_Module FOREIGN KEY (ModuleCode) 
    REFERENCES Module(ModuleCode) ON DELETE CASCADE -- Cascades deletion of module to related studies records
);

-- Population of data in the tablas

-- Inserting Department records
Insert into DEPARTMENT (DEPARTMENTID,NAME,PHONE,FAX,LOCATION,MANAGERID) values 
(1,'Computer Science','123-456','123-789','E Block'      ,101),
(2,'Business','234-567','234-890','C Block'              ,102),
(3,'Mathematics','345-678','345-901','E Block'           ,103),
(4,'Electrical Engineering','456-789','456-012','F Block',104),
(5,'Physics','567-890','567-123','D Block'               ,105),
(6,'CIS','678-901','678-234','B Block'                   ,106),
(7,'Psychology','789-012','789-345','E Block'            ,107),
(8,'Sociology','890-123','890-456','A Block'             ,108),
(9,'Chemistry','901-234','901-567','F Block'             ,109),
(10,'Biology','012-345','012-678','G Block'              ,110);

SELECT * FROM DEPARTMENT; 


 -- Inserting ACADEMICSTAFF records
Insert into ACADEMICSTAFF (STAFFID,FIRSTNAME,LASTNAME,PHONEEXTENSION,OFFICENUMBER,
            SEX,SALARY,POST,QUALIFICATIONS,ADDRESS,WORKSFORDEPARTMENTID) values
(111,'Emilio','Barrera','1244','A111','M',55555,'Lecturer','Master in CIS','A Block, Room 111',6),
(112,'Emily','Wella','1245','A112','F',45000,'Professor','Doctorate in Psychology','G Block, Room 110',6),
(113,'Adele','Clary','1246','A113','F',90009,'Lecturer','Expert in Electrical Engineering','E Block, Room 1',6),
(114,'Agel','Angel','1247','A114','F',54321,'Researcher','PhD in researcher','A Block, Room 111',6),
(101,'Alice','Smith','1234','A101','F',55000,'Professor','PhD in Computer Science','E Block, Room 101',1),
(102,'John','Doe','1235','A102','M',60000,'Lecturer','PhD in Business Administration','C Block, Room 102',2),
(103,'Mary','Johnson','1236','A103','F',65000,'Professor','PhD in Mathematics','E Block, Room 103',3),
(104,'Peter','Brown','1237','A104','M',70000,'Senior Lecturer','Expert in Electrical Engineering','F Block, Room 104',4),
(105,'Linda','Williams','1238','A105','F',62000,'Lecturer','PhD in Physics','D Block, Room 105',5),
(106,'Robert','Taylor','1239','A106','M',80000,'Professor','PhD in CIS','B Block, Room 106',6),
(107,'Nancy','Davis','1240','A107','F',58000,'Lecturer','Doctorate in Psychology','E Block, Room 107',7),
(108,'James','Martinez','1241','A108','M',59000,'Senior Lecturer','PhD in Sociology','A Block, Room 108',8),
(109,'Patricia','Garcia','1242','A109','F',63000,'Lecturer','professional in Chemistry','F Block, Room 109',9),
(110,'Charles','Lopez','1243','A110','M',65000,'Professor','PhD in Biology','G Block, Room 110',10);

-- Inserting course records
INSERT INTO Course (CourseCode, Title, Duration, DepartmentID, ManagerID) VALUES
('CS101', 'Introduction to Computer Science', 3, 1, 101 ),
('BUS202', 'Business Fundamentals'          , 4, 1 ,102),
('MATH303', 'Advanced Mathematics'          , 3, 2, 103 ),
('EE404', 'Electrical Engineering Basics'   , 4, 2, 104 ),
('PHYS505', 'Physics for Engineers'         , 3, 3, 105 ),
('LAW606', 'Introduction to Law'            , 3, 3, 106 ),
('PSY707', 'Psychology 101'                 , 3, 4, 107 ),
('BIO808', 'Biology for Science Students'   , 3, 4, 108 ),
('CHEM909', 'Chemistry for Beginners'       , 4, 5, 109),
('ART101', 'Art Appreciation'               , 3, 5, 110),
('PgDIT', 'Postgraduate Diploma in Information Technology', 4, 1, 111);

-- Inserting Studens records
INSERT INTO STUDENT (MATRICNO,FIRSTNAME,LASTNAME,DOB,SEX,FINANCIALLOAN,COURSECODE) values 
('S0011','Lucas','Galilei',to_date('14-MAY-00','DD-MON-RR'),'F',5000,'PgDIT'),
('S0012','Lina','Moni',to_date('23-AUG-99','DD-MON-RR'),'M',3000,'PgDIT'),
('S0013','Camilo','Suarez',to_date('12-NOV-01','DD-MON-RR'),'F',4000,'PgDIT'),
('S0014','Jaime','Olmes',to_date('09-MAR-98','DD-MON-RR'),'M',2000,'PgDIT'),
('S0015','Isabella','Anderson',to_date('15-FEB-01','DD-MON-RR'),'F',3000,'PgDIT'),
('S0016','Ethan','Thomas',to_date('23-NOV-00','DD-MON-RR'),'M',4000,'PgDIT'),
('S0017','Olivia','Brown',to_date('18-JUL-99','DD-MON-RR'),'F',2500,'PgDIT'),
('S0018','Liam','Taylor',to_date('12-JAN-02','DD-MON-RR'),'M',2000,'PgDIT'),
('S0019','Sophia','White',to_date('25-MAR-01','DD-MON-RR'),'F',3500,'PgDIT'),
('S0020','Mason','Clark',to_date('05-SEP-98','DD-MON-RR'),'M',4500,'PgDIT'),
('S0021','Emily','Walker',to_date('14-JUN-00','DD-MON-RR'),'F',4000,'PgDIT'),
('S0022','Noah','Harris',to_date('01-DEC-01','DD-MON-RR'),'M',3000,'PgDIT'),
('S0023','Ava','Lewis',to_date('27-MAY-00','DD-MON-RR'),'F',2500,'PgDIT'),
('S0024','Lucas','King',to_date('19-AUG-02','DD-MON-RR'),'M',5000,'PgDIT'),
('S025','Ella','Hall',to_date('07-NOV-01','DD-MON-RR'),'F',4200,'PgDIT'),
('S0126','James','Allen',to_date('02-FEB-00','DD-MON-RR'),'M',3700,'PgDIT'),
('S0127','Amelia','Scott',to_date('31-DEC-99','DD-MON-RR'),'F',3200,'PgDIT'),
('S0028','Benjamin','Wright',to_date('13-JUL-02','DD-MON-RR'),'M',2900,'PgDIT'),
('S0029','Chloe','Young',to_date('10-SEP-01','DD-MON-RR'),'F',2800,'PgDIT'),
('S0030','Henry','Adams',to_date('22-OCT-00','DD-MON-RR'),'M',3100,'PgDIT'),
('S0031','Charlotte','Nelson',to_date('03-AUG-99','DD-MON-RR'),'F',4000,'PgDIT'),
('S0032','Daniel','Carter',to_date('09-APR-01','DD-MON-RR'),'M',3500,'PgDIT'),
('S0033','Grace','Mitchell',to_date('15-MAR-02','DD-MON-RR'),'F',3700,'PgDIT');

-- Inserting next of kin records
INSERT INTO NextOfKin (KinID, Name, Address, Phone, Relationship, StudentID) VALUES
(1, 'John Johnson', '123 Main St', '555-1234', 'Father', 'S001'),
(2, 'Mary Williams', '456 Oak St', '555-5678', 'Mother', 'S002'),
(3, 'Sophia Brown', '789 Pine St', '555-8765', 'Sister', 'S003'),
(4, 'Robert Jones', '321 Maple St', '555-4321', 'Father', 'S004'),
(5, 'Jennifer Davis', '654 Elm St', '555-6543', 'Mother', 'S005'),
(6, 'David Miller', '987 Cedar St', '555-8760', 'Father', 'S006'),
(7, 'Laura Taylor', '654 Birch St', '555-3210', 'Mother', 'S007'),
(8, 'James Anderson', '123 Pine St', '555-9876', 'Father', 'S008'),
(9, 'Linda Thomas', '456 Cedar St', '555-5555', 'Mother', 'S009'),
(10, 'Michael Jackson', '789 Birch St', '555-2222', 'Father', 'S010');

INSERT INTO Module (ModuleCode, Title, StartDate, EndDate, Texts, AssessmentScheme, CoordinatorID, CourseCode) VALUES
('CS1011', 'Introduction to Programming', TO_DATE('01-JAN-2023', 'DD-MON-YYYY'), TO_DATE('31-DEC-2023', 
'DD-MON-YYYY'), 'Textbook A', 'Exam-based', 101, 'CS101'),
('BUS2021', 'Business Analytics', TO_DATE('01-JAN-2023', 'DD-MON-YYYY'), TO_DATE('31-DEC-2023', 'DD-MON-YYYY'), 
'Textbook B', 'Project-based', 102, 'BUS202'),
('MATH3031', 'Differential Equations', TO_DATE('01-FEB-2023', 'DD-MON-YYYY'), TO_DATE('31-JAN-2024', 'DD-MON-YYYY'), 
'Textbook C', 'Mixed', 103, 'MATH303'),
('EE4041', 'Signal Processing', TO_DATE('01-MAR-2023', 'DD-MON-YYYY'), TO_DATE('28-FEB-2024', 'DD-MON-YYYY'), 'Textbook D', 
'Exam-based', 104, 'EE404'),
('PHYS5051', 'Quantum Mechanics', TO_DATE('01-APR-2023', 'DD-MON-YYYY'), TO_DATE('31-MAR-2024', 'DD-MON-YYYY'), 'Textbook E', 
'Project-based', 105, 'PHYS505'),
('LAW6061', 'Constitutional Law', TO_DATE('01-MAY-2023', 'DD-MON-YYYY'), TO_DATE('30-APR-2024', 'DD-MON-YYYY'), 'Textbook F', 
'Mixed', 106, 'LAW606'),
('PSYC7071', 'Therapeutic Techniques', TO_DATE('01-JUN-2023', 'DD-MON-YYYY'), TO_DATE('31-MAY-2024', 'DD-MON-YYYY'), 'Textbook G', 
'Exam-based', 107, 'PSY707'),
('SOC8081', 'Global Sociological Trends', TO_DATE('01-JUL-2023', 'DD-MON-YYYY'), TO_DATE('30-JUN-2024', 'DD-MON-YYYY'), 'Textbook H', 
'Project-based', 108, 'PgDIT'),
('CHEM9091', 'Lab Techniques in Chemistry', TO_DATE('01-AUG-2023', 'DD-MON-YYYY'), TO_DATE('31-JUL-2024', 'DD-MON-YYYY'), 'Textbook I', 
'Mixed', 109, 'CHEM909'),
('BIO1011', 'Genetics', TO_DATE('01-SEP-2023', 'DD-MON-YYYY'), TO_DATE('31-AUG-2024', 'DD-MON-YYYY'), 'Textbook J', 'Project-based', 110,
'BIO808');

SELECT * FROM Performance;
-- Inserting Performance
INSERT INTO Performance (StudentID, ModuleCode, PassOrFail) VALUES
('S001', 'CS1011'    , 'P'),
('S002', 'BUS2021'   , 'P'),
('S003', 'MATH3031'  , 'F'),
('S004', 'EE4041'    , 'P'),
('S005', 'PHYS5051'  , 'F'),
('S006', 'LAW6061'   , 'P'),
('S007', 'PSYC7071'  , 'P'),
('S008', 'SOC8081'   , 'F'),
('S009', 'CHEM9091'  , 'P'),
('S010', 'BIO1011'   , 'P');


-- Insert records into the Enrollment table
INSERT INTO Enrollment (EnrollmentID, StudentID, CourseCode, EnrollmentDate, Grade)VALUES 
(1, 'S001', 'CS101', TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'A'), 
(2, 'S002', 'ART101', TO_DATE('2024-02-15', 'YYYY-MM-DD'), 'B'),
(3, 'S003', 'CHEM909', TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'C'),
(4, 'S0034', 'BIO808', TO_DATE('2024-04-25', 'YYYY-MM-DD'), 'C'),
(5, 'S004', 'PSY707', TO_DATE('2024-05-30', 'YYYY-MM-DD'), 'B'),
(6, 'S005', 'LAW606', TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'A'),
(7, 'S006', 'PHYS505', TO_DATE('2024-07-10', 'YYYY-MM-DD'), 'A'),
(8, 'S007', 'EE404', TO_DATE('2024-08-15', 'YYYY-MM-DD'), 'B'),
(9, 'S008', 'MATH303', TO_DATE('2024-09-20', 'YYYY-MM-DD'), 'C'),
(10, 'S009', 'BUS202', TO_DATE('2024-10-25', 'YYYY-MM-DD'), 'B');

SELECT * FROM Enrollment;


-- Inserting TaughtBY records
INSERT INTO TaughtBY (StaffID, ModuleCode) VALUES
(101, 'CS1011'   ),  
(102, 'BUS2021'  ),
(103, 'MATH3031' ),
(104, 'EE4041'   ),
(105, 'PHYS5051' ),
(106, 'LAW6061'  ),
(107, 'PSYC7071' ),
(108, 'SOC8081'  ),
(109, 'CHEM9091' ),
(110, 'BIO1011'  );




-- Inserting Studies records
INSERT INTO Studies (StudentID, ModuleCode) VALUES
('S001', 'CS1011'  ),
('S002', 'BUS2021' ),
('S003', 'MATH3031'),
('S0034','EE4041'  ),
('S004', 'PHYS5051'),
('S005', 'LAW6061' ),
('S006', 'PSYC7071'),
('S007', 'SOC8081' ),
('S008', 'CHEM9091'),
('S009', 'PGDIT104' ),
('S010', 'PGDIT104' ),
('S0011','PGDIT104' ),
('S0012','PGDIT104' ),
('S0013','PGDIT104' ),
('S0014','PGDIT104' ),
('S0015','PGDIT104' ),
('S0016','PGDIT104' ),
('S0017','PGDIT104' ),
('S0018','PGDIT104' ),
('S0019','PGDIT104' ),
('S0020','PGDIT104' ),
('S0021','PGDIT104' ),
('S0022','PGDIT104' ),
('S0023','CS1011' ),
('S0024','BIO1011' ),
('S025', 'CHEM9091' ),
('S0126','SOC8081' ),
('S0127','PSYC7071' ),
('S0028','LAW6061' ),
('S0029','PHYS5051' ),
('S0030','EE4041' ),
('S0031','MATH3031' ),
('S0032','BUS2021' ),
('S0033','CS1011' );

-- Inserting Teacher
INSERT INTO Teacher (StaffID, ModuleCode, HoursPerWeek) VALUES
(101, 'CS1011', 8),
(102, 'BUS2021', 6),
(103, 'MATH3031', 10),
(104, 'EE4041', 7),
(105, 'PHYS5051', 8),
(106, 'LAW6061', 9),
(107, 'PSYC7071', 5),
(108, 'SOC8081', 7),
(109, 'CHEM9091', 4),
(110, 'BIO1011', 6);



--DOne
-- (a) List details of all departments located in E Block.
SELECT * 
FROM Department
WHERE Location = 'E Block';

SELECT 
    DepartmentID, 
    Name AS "Department Name", 
    Phone AS "Phone Number", 
    Fax AS "Fax Number", 
    Location AS "Location", 
    ManagerID AS "Manager ID"
FROM 
    Department
WHERE 
    Location = 'E Block';


-- Done (b) List title, start, and end dates of all modules run in the PgDIT course.
SELECT M.Title, M.StartDate, M.EndDate
FROM Module M
JOIN Course C ON M.CourseCode = C.CourseCode
WHERE C.Title = 'PgDIT';

SELECT * FROM module;
SELECT * FROM course;

SELECT 
    m.Title AS "Module Title",
    m.StartDate AS "Start Date",
    m.EndDate AS "End Date"
FROM 
    Module m
JOIN 
    Course c ON m.CourseCode = c.CourseCode
WHERE 
    c.Title = 'PgDIT';


-- Done (c)
SELECT A.FirstName, A.LastName, A.Address, A.Salary
FROM AcademicStaff A
JOIN Department D ON A.StaffID = D.ManagerID
WHERE A.Sex = 'F';

SELECT 
    A.FirstName || ' ' || A.LastName AS "Full Name",
    A.Address AS "Address",
    A.Salary AS "Salary"
FROM 
    AcademicStaff A
INNER JOIN 
    Department D
ON 
    A.StaffID = D.ManagerID
WHERE 
    A.Sex = 'F';



-- Done (D)
SELECT FirstName, LastName, Sex, Salary
FROM AcademicStaff
WHERE Post = 'Lecturer' 
    AND Qualifications LIKE '%PhD%';

SELECT 
    FirstName || ' ' || LastName AS "Full Name",
    Sex,
    Salary 
FROM 
    AcademicStaff
WHERE 
    Post = 'Lecturer' AND Qualifications LIKE '%PhD%';
   
   
   
   
    
SELECT * FROM AcademicStaff;


-- Done (e)
SELECT 
    A.LastName, 
    A.Post, 
    A.Qualifications
FROM 
    AcademicStaff A
JOIN 
    Department D ON A.WorksForDepartmentID = D.DepartmentID
WHERE 
    D.Name = 'CIS';

SELECT 
    LastName, 
    Post, 
    Qualifications
FROM 
    AcademicStaff
WHERE 
    WorksForDepartmentID = (SELECT DepartmentID FROM Department WHERE Name = 'CIS');


-- Done (f)
SELECT S.MatricNo, S.LastName, S.Sex
FROM Student S
JOIN Studies St ON S.MatricNo = St.StudentID
JOIN Module M ON St.ModuleCode = M.ModuleCode
WHERE M.Title = 'Multi-media'
ORDER BY S.LastName;

SELECT 
    S.MatricNo AS "Matriculation Number", 
    S.LastName AS "Last Name", 
    S.Sex
FROM 
    Student S
JOIN 
    Studies ST ON S.MatricNo = ST.StudentID
JOIN 
    Module M ON ST.ModuleCode = M.ModuleCode
WHERE 
    M.Title = 'Multi-media'
ORDER BY 
    S.LastName;

SELECT * FROM module;
SELECT * FROM Student;
SELECT * FROM Studies;

-- Done (g)
SELECT StaffID, LastName, Sex, Post
FROM AcademicStaff
WHERE Salary > (SELECT AVG(Salary) FROM AcademicStaff);

SELECT 
    StaffID AS "Staff Number",
    LastName AS "Last Name",
    Sex,
    Post
FROM 
    AcademicStaff
WHERE 
    Salary > (SELECT AVG(Salary) FROM AcademicStaff);




-- Done (h)
SELECT C.Title AS CourseTitle, COUNT(S.MatricNo) AS NumberOfStudents
FROM Course C
JOIN Student S ON C.CourseCode = S.CourseCode
GROUP BY C.Title
HAVING COUNT(S.MatricNo) > 10;

SELECT 
    C.Title AS "Course Title",
    COUNT(S.MatricNo) AS "Number of Students"
FROM 
    Course C
JOIN 
    Student S ON C.CourseCode = S.CourseCode
GROUP BY 
    C.Title
HAVING 
    COUNT(S.MatricNo) > 10;


-- (i) Done
SELECT 
    SUM(CASE WHEN A.Sex = 'F' THEN 1 ELSE 0 END) AS FemaleStaff,
    SUM(CASE WHEN A.Sex = 'M' THEN 1 ELSE 0 END) AS MaleStaff
FROM 
    AcademicStaff A
JOIN 
    Department D ON A.WorksForDepartmentID = D.DepartmentID
WHERE 
    D.Name = 'CIS';

SELECT 
    Sex AS "Gender",
    COUNT(*) AS "Number of Staff"
FROM 
    AcademicStaff
WHERE 
    WorksForDepartmentID = (SELECT DepartmentID FROM Department WHERE Name = 'CIS')
GROUP BY 
    Sex;


-- Done (j)
SELECT A.LastName, M.Title AS ModuleTitle, T.HoursPerWeek
FROM AcademicStaff A
JOIN Teacher T ON A.StaffID = T.StaffID
JOIN Module M ON T.ModuleCode = M.ModuleCode
WHERE T.HoursPerWeek > 6;

SELECT 
    A.LastName AS "Staff Last Name",
    M.Title AS "Module Title",
    T.HoursPerWeek AS "Hours Per Week"
FROM 
    AcademicStaff A
JOIN 
    Teacher T ON A.StaffID = T.StaffID
JOIN 
    Module M ON T.ModuleCode = M.ModuleCode
WHERE 
    T.HoursPerWeek > 6;


-- Done (k)
SELECT D.Name AS DepartmentName,
       SUM(CASE WHEN A.Sex = 'F' THEN 1 ELSE 0 END) AS FemaleStaff,
       SUM(CASE WHEN A.Sex = 'M' THEN 1 ELSE 0 END) AS MaleStaff
FROM Department D
JOIN AcademicStaff A ON D.DepartmentID = A.WorksForDepartmentID
GROUP BY D.Name;

SELECT 
    d.Name AS "Department Name",
    SUM(CASE WHEN a.Sex = 'F' THEN 1 ELSE 0 END) AS "Number of Female Staff",
    SUM(CASE WHEN a.Sex = 'M' THEN 1 ELSE 0 END) AS "Number of Male Staff"
FROM 
    Department d
LEFT JOIN 
    AcademicStaff a ON d.DepartmentID = a.WorksForDepartmentID
GROUP BY 
    d.Name
ORDER BY 
    d.Name;


INSERT INTO Module (ModuleCode, Title, StartDate, EndDate, Texts, AssessmentScheme, CoordinatorID, CourseCode)
VALUES 
('PGDIT101', 'Advanced Programming', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 
 'Comprehensive textbook on Java programming', 'Exams and Project', 101, 'PgDIT'),

('PGDIT102', 'Database Systems', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 
 'Database Management System textbook', 'Exams and Case Study', 102, 'PgDIT'),

('PGDIT103', 'Networking Essentials', TO_DATE('2024-01-01', 'YYYY-MM-DD'), TO_DATE('2024-12-31', 'YYYY-MM-DD'), 
 'Networking principles and practices', 'Exams and Group Project', 103, 'PgDIT');

INSERT INTO Module (ModuleCode, Title, StartDate, EndDate, Texts, AssessmentScheme, CoordinatorID, CourseCode)
VALUES 
('PGDIT104', 'Multi-media', TO_DATE('2024-01-15', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), 
 'Recommended: "Interactive Media Design" by John Smith', 'Project and Exam', 105, 'PgDIT');
 
 SELECT * FROM Student;
 
INSERT INTO Student (MatricNo, FirstName, LastName, Address, DOB, Sex, FinancialLoan, CourseCode)
VALUES 
('S0011', 'Lucas', 'Galilei', '123 Baker Street, London', TO_DATE('2000-05-14', 'YYYY-MM-DD'), 'F', 5000.00, 'PgDIT'),
('S0012', 'Lina', 'Moni', '456 Elm Street, Manchester', TO_DATE('1999-08-23', 'YYYY-MM-DD'), 'M', 3000.00, 'PgDIT'),
('S0013', 'Camilo', 'Suarez', '789 Maple Avenue, Edinburgh', TO_DATE('2001-11-12', 'YYYY-MM-DD'), 'F', 4000.00, 'PgDIT'),
('S0014', 'Jaime', 'Olmes', '321 Oak Lane, Bristol', TO_DATE('1998-03-09', 'YYYY-MM-DD'), 'M', 2000.00, 'PgDIT');
INSERT INTO Studies (StudentID, ModuleCode)
VALUES
('S001', 'PGDIT104'), -- Emily Johnson
('S002', 'PGDIT104'), -- James Williams
('S003', 'PGDIT104'), -- Sophia Brown
('S004', 'PGDIT104'); -- Michael Jones

-- 6. Query: Student Enrollment by Module.  
SELECT 
    m.Title AS "Module", 
    COUNT(s.MatricNo) AS "Enrolled Students"
FROM 
    Module m
LEFT JOIN 
    Studies st ON m.ModuleCode = st.ModuleCode
LEFT JOIN 
    Student s ON st.StudentID = s.MatricNo
GROUP BY 
    m.Title;

-- 7 Staff Managing Departments with Fewer than 5 Courses
SELECT a.FirstName, a.LastName
FROM AcademicStaff a
JOIN Department d ON a.StaffID = d.ManagerID
WHERE d.DepartmentID IN (
    SELECT DepartmentID
    FROM Course
    GROUP BY DepartmentID
    HAVING COUNT(CourseCode) < 5
);


-- 8. Query retrieve Student with Financial Loands Greater than 5000
SELECT 
    FirstName AS "First Name", 
    LastName AS "Last NAme", 
    Address
FROM 
    Student
WHERE
    FinancialLoan > 5000;



--1. Query: List all courses with their department names and the number of students enrolled.

SELECT 
    C.Title AS "Course Title",
    D.Name AS "Department Name",
    COUNT(S.MatricNo) AS "Number of Students"
FROM 
    Course C
JOIN 
    Department D ON C.DepartmentID = D.DepartmentID
JOIN 
    Student S ON C.CourseCode = S.CourseCode
GROUP BY 
    C.Title, D.Name
ORDER BY 
    "Number of Students" DESC;

-- 2. Query: Find the average salary of staff in each department   
SELECT 
    D.Name AS "Department Name", 
    AVG(A.Salary) AS "Average Salary"
FROM 
    AcademicStaff A
JOIN 
    Department D ON A.WorksForDepartmentID = D.DepartmentID
GROUP BY 
    D.Name
ORDER BY 
    "Average Salary" DESC;
 
 -- 3. Query: Retrieve details of all students who are enrolled in a course in the 
 -- 'Computer Science' department.   
SELECT 
    S.FirstName, 
    S.LastName, 
    S.MatricNo, 
    S.CourseCode 
FROM 
    Student S
JOIN 
    Course C ON S.CourseCode = C.CourseCode
JOIN 
    Department D ON C.DepartmentID = D.DepartmentID
WHERE 
    D.Name = 'Computer Science';
    
   
-- 5 Query: Retrieve the number of courses offered by each department.  
SELECT 
    D.Name AS "Department Name", 
    COUNT(C.CourseCode) AS "Number of Courses"
FROM 
    Department D
LEFT JOIN 
    Course C ON D.DepartmentID = C.DepartmentID
GROUP BY 
    D.Name;
    
    
  
-- 3 Query: Gender Distribution of Students Enrolled in the CS101     	Course.  
SELECT 
    Sex AS "Gender",
    COUNT(*) AS "Number of Students"
FROM 
    Student
WHERE 
    CourseCode = 'CS101'
GROUP BY 
    Sex;
    

-- 9. Query Students' Pass/Fail Status for the 'PgDIT' Course     
SELECT 
    S.FirstName AS "First Name", 
    S.LastName AS "LAst Name", 
    P.PassOrFail AS "Pass or Fail"
FROM 
    Student S
JOIN 
    Performance P ON S.MatricNo = P.StudentID
JOIN 
    Module M ON P.ModuleCode = M.ModuleCode
WHERE 
    M.CourseCode = 'PgDIT'; 

  

-- 10. Query retrieve Departments Managed by Academic Staff
SELECT 
    A.FirstName AS "First Name", 
    A.LastName AS "Last Name", 
    COUNT(D.DepartmentID) AS "Departments Managed"
FROM 
    AcademicStaff A
JOIN 
    Department D ON A.StaffID = D.ManagerID
GROUP BY 
    A.FirstName, A.LastName
HAVING 
    COUNT(D.DepartmentID) > 1;
    
