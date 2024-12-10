
-- (h)For each course with more than 10 students, list course
-- title and the number of students (under an appropriate header).
SELECT 
    C.Title AS "Course Title",
    COUNT(S.MatricNo) AS "Number of Students"
FROM 
    Course C
JOIN 
    Student S ON C.CourseCode = S.CourseCode
GROUP BY 
    C.Title
HAVING 
    COUNT(S.MatricNo) > 10;