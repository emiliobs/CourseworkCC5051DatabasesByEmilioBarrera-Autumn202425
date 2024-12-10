
-- (c)List name, address, and salary for each female member 
--of academic staff who manages a department.
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