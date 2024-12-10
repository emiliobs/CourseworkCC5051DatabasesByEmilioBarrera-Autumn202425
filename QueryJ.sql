
-- (j)For each member of academic staff who spends more
-- than 6 hours teaching any module list the member of 
-- academic staff last name, the module title and 
-- the number of hours.

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