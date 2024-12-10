
-- (a) List details of all departments located in E Block.
SELECT 
    DepartmentID, 
    Name AS "Department Name", 
    Phone AS "Phone Number", 
    Fax AS "Fax Number", 
    Location, 
    ManagerID AS "Manager ID"
FROM 
    Department
WHERE 
    Location = 'E Block';