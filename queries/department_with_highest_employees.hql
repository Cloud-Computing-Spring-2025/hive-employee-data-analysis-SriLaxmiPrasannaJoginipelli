SELECT department, COUNT(*) AS total_employees 
FROM employees 
GROUP BY department 
ORDER BY total_employees DESC 
LIMIT 1;