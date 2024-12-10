
-- (f) List matriculation number, last name, and sex of all students 
-- who are studying 'multi-media' module. Order result alphabetically 
-- by last name.

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