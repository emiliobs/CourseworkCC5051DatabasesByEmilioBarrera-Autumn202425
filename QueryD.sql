
-- (d)List name, sex, and salary for each lecturer with a PhD degree.
SELECT 
    FirstName || ' ' || LastName AS "Full Name",
    Sex,
    Salary 
FROM 
    AcademicStaff
WHERE 
    Post = 'Lecturer' AND Qualifications LIKE '%PhD%';