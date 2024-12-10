
--(b)List title, start and end dates of all modules run in the PgDIT course.

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