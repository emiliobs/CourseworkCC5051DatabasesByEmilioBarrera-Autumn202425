
--(k)For each department list the department name, and the number of female
-- members of academic staff, and the number of male members of academic staff 
--under appropriate headers (use a crosstab query).

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