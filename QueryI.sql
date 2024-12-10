
--(i)List the number of female members of academic staff and the number of male 
-- members of academic staff employed by CIS department.

SELECT 
    Sex AS "Gender",
    COUNT(*) AS "Number of Staff"
FROM 
    AcademicStaff
WHERE 
    WorksForDepartmentID = (SELECT DepartmentID FROM Department WHERE Name = 'CIS')
GROUP BY 
    Sex;