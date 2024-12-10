
-- (g)List staff number, last name, sex, and post of all academic staff whose 
-- salary is greater than the average salary of all academic staff.

SELECT 
    StaffID AS "Staff Number",
    LastName AS "Last Name",
    Sex,
    Post
FROM 
    AcademicStaff
WHERE 
    Salary > (SELECT AVG(Salary) FROM AcademicStaff);