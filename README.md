# Hive Employee Data Analysis

## Project Overview

Using Apache Hive, the **Hive Employee Data Analysis** project seeks to analyze employee data. Employee ID, name, age, employment role, pay, project assignment, join date, and department are among the details included in the dataset. The project uses HiveQL queries to process this data and provide insights.

### **Key Objectives**

- Examine the pay of employees in various departments.
- Determine which employees fit the project, pay, and join date criteria.
- Compute aggregate data, such as personnel counts and rankings by department..
- Eliminate records with missing values to clean up the data.

## Implementation

### **1. Environment Setup**

1. **Start Hive and Hadoop Containers:**
   ```bash
   docker-compose up -d
   ```

2. **Access the Namenode Container:**
   ```bash
   docker exec -it namenode /bin/bash
   ```

3. **Data into Hadoop:**
   ```bash
   docker cp /workspaces/hive-employee-data-analysis-SriLaxmiPrasannaJoginipelli/input_dataset/employees.csv namenode:/tmp/employees.csv
   ```

   ```bash
   docker cp /workspaces/hive-employee-data-analysis-SriLaxmiPrasannaJoginipelli/input_dataset/departments.csv namenode:/tmp/departments.csv
   ```

4. **Make a directory:**
   ```bash
   hdfs dfs -mkdir -p /user/hive/warehouse/input_dataset/
   ```
5. **Data into hive:**
   ```bash
   hdfs dfs -put /tmp/employees.csv /user/hive/warehouse/input_dataset/
   ```

   ```bash
   hdfs dfs -put /tmp/departments.csv /user/hive/warehouse/input_dataset/
   ```
6. **Load data in Hive:**
   ```sql
   LOAD DATA INPATH '/user/hive/warehouse/input_dataset/employees.csv' INTO TABLE temp_employees;

   ```
   ```sql
   LOAD DATA INPATH '/user/hive/warehouse/input_dataset/departments.csv' INTO TABLE temp_departments;
   ```

### **2. Executing Queries**

### **1. Employees Who Joined After 2015**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/employees_after_2015'
SELECT * FROM employees WHERE year(join_date) > 2015;
```

**Output:** Stored in `output/employees_after_2015/000000_0`

---

### **2. Average Salary by Department**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/average_salary_by_department'
SELECT department, AVG(salary) AS avg_salary FROM employees GROUP BY department;
```

**Output:** Stored in `output/average_salary_by_department/000000_0`

---

### **3. Employees Working on 'Alpha' Project**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/employees_on_alpha_project'
SELECT * FROM employees WHERE project = 'Alpha';
```

**Output:** Stored in `output/employees_on_alpha_project/000000_0`

---

### **4. Employee Count by Job Role**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/employee_count_by_job_role'
SELECT job_role, COUNT(*) AS total_employees FROM employees GROUP BY job_role;
```

**Output:** Stored in `output/employee_count_by_job_role/000000_0`

---

### **5. Employees Earning Above Department Average**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/employees_above_avg_salary'
SELECT e.*
FROM employees e
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) dept_avg
ON e.department = dept_avg.department
WHERE e.salary > dept_avg.avg_salary;
```

**Output:** Stored in `output/employees_above_avg_salary/000000_0`

---

### **6. Department with Highest Number of Employees**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/department_with_highest_employees'
SELECT department, COUNT(*) AS total_employees
FROM employees
GROUP BY department
ORDER BY total_employees DESC
LIMIT 1;
```

**Output:** Stored in `output/department_with_highest_employees/000000_0`

---

### **7. Employees Without Null Values**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/employees_without_null_values'
SELECT * FROM employees
WHERE emp_id IS NOT NULL
AND name IS NOT NULL
AND age IS NOT NULL
AND job_role IS NOT NULL
AND salary IS NOT NULL
AND project IS NOT NULL
AND join_date IS NOT NULL
AND department IS NOT NULL;
```

**Output:** Stored in `output/employees_without_null_values/000000_0`

---

### **8. Employees with Department Locations**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/employees_with_department_location'
SELECT e.*, d.location
FROM employees e
JOIN temp_departments d ON e.department = d.department_name;
```

**Output:** Stored in `output/employees_with_department_location/000000_0`

---

### **9. Employee Salary Ranking within Departments**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/employee_ranking_by_salary'
SELECT *, RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
FROM employees;
```

**Output:** Stored in `output/employee_ranking_by_salary/000000_0`

---

### **10. Top 3 Highest Paid Employees Per Department**

**Query:**

```sql
INSERT OVERWRITE DIRECTORY '/user/hive/warehouse/query_results/top_3_highest_paid_employees_by_department'
SELECT * FROM (
    SELECT *,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank
    FROM employees
) ranked
WHERE rank <= 3;
```

**Output:** Stored in `output/top_3_highest_paid_employees_by_department/000000_0`

### *Fetching Output to Local: *###

```bash
mkdir -p /output
```

```bash
hdfs dfs -get /user/hive/warehouse/query_results/* /output/
```

```bash
docker cp d70b9cb63a06:/workspaces/hive-employee-data-analysis-SriLaxmiPrasannaJoginipelli/output ./output
```

## Conclusion

This project shows how to efficiently query and analyze huge employee databases using **HiveQL**. For more intricate analytics like trend analysis, forecasts, and real-time insights, the methodology can be expanded.

