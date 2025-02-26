SELECT e.*, d.location
FROM employees e
JOIN temp_departments d ON e.department = d.department_name;