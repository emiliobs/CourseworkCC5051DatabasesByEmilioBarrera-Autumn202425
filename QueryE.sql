
-- (e)List last name, post, and qualifications of all members 
-- of academic staff who are employed by CIS department.
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