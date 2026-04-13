--CREATE DATABASE EmploDepartment;

CREATE TABLE Departments (
    Dept_id   INT PRIMARY KEY,
    Dept_name VARCHAR(50) NOT NULL
);

-- 3. Create Employees Table
CREATE TABLE Employees (
    Emp_id    INT PRIMARY KEY,
    Emp_name  VARCHAR(50) NOT NULL,
    Salary    INT NOT NULL,
    Dept_id   INT
);

-- 4. Insert Data into Departments
INSERT INTO Departments (Dept_id, Dept_name) VALUES
(10, 'Sales'),
(20, 'IT'),
(30, 'HR'),
(40, 'Legal');

-- 5. Insert Data into Employees
INSERT INTO Employees (Emp_id, Emp_name, Salary, Dept_id) VALUES
(1, 'Neo',    5000, 10),
(2, 'Amina',  7000, 20),
(3, 'Thabo',  6000, 20),
(4, 'Mia',    4000, 50);

-- Verify the data
SELECT * FROM Departments;
SELECT * FROM Employees;

--1. Assign a row number to catch employee based on salary (highest first)
SELECT emp_id,
       emp_name,
       salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_number
FROM employees;

--2. Rank employees by salary using RANK()
SELECT emp_id,
       emp_name,
       salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;


--3. Rank employees by salary using DENSE_RANK()
SELECT emp_id,
       emp_name,
       salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_dense_rank
FROM employees;


--4.What is the difference between RANK() and ROW_NUMBER()
select emp_id,
       emp_name,
       salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_number
       from employees;


--5.Show each employee with the average salary of the entire company.
SELECT emp_id,
       emp_name,
       salary,
       AVG(salary) OVER() AS avg_Salary
FROM employees;

--6. Assign row numbers within each department based on salary
SELECT emp_id,
       emp_name,
       salary,
       Dept_id,
       ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY salary DESC) AS row_num
FROM employees;


--7.Find the highest paid employee in each department

SELECT emp_name, 
       salary, 
       dept_id
FROM (
    SELECT emp_name,
           dept_id,
           salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS Ranked_Salary
    FROM employees
) AS ranked   
WHERE Ranked_Salary = 1;



--8.Show each employee with the average salary of their department
SELECT emp_name,
       salary,
       dept_id,
       AVG(salary) OVER(PARTITION BY dept_id) AS dept_avg
FROM employees;

--9. Show the previous employees salary
SELECT emp_name,
       salary,
       dept_id,
       LAG(salary) OVER(ORDER BY emp_id) AS Prev_Salary
FROM employees;


--10. Show the next employees salary
SELECT emp_name,
       salary,
       dept_id,
       LEAD(salary) OVER(ORDER BY emp_id) AS Next_Salary
FROM employees;


--11. Calculate the difference between each employees salary and the previous salary
SELECT emp_id,
       emp_name,
       salary,
       salary - LAG(salary) OVER(ORDER BY emp_id) AS Prev_salary
FROM employees;


--12.Find the top 2 highest paid in each department
--Method 1
SELECT emp_name,
       salary,
       dept_id
FROM (
    SELECT emp_name,
           dept_id,
           salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS Ranked_Salary
    FROM employees
) AS ranked         
WHERE Ranked_Salary <= 2;



---13.Calculate a running total of salaries ordered by emp_id
SELECT emp_id,
       emp_name,
       salary,
       SUM(salary) OVER (ORDER BY emp_id) AS Running_Total
FROM employees;


---14.Find employees whose salary is higher than the department average

WITH employee_with_avg AS (
    SELECT emp_id,
           emp_name,
           salary,
           dept_id,
           AVG(salary) OVER (PARTITION BY dept_id) AS Dept_Avg
    FROM employees
)
SELECT emp_id,
       emp_name,
       salary,
       dept_id,
       Dept_Avg
FROM employee_with_avg
WHERE salary > Dept_Avg
ORDER BY dept_id, salary DESC;

--15.Rank employees within each department and return only rank =1 and 2
SELECT emp_name,
       salary,
       dept_id
FROM (
    SELECT emp_name,
           dept_id,
           salary,
           RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS Ranked_Salary
    FROM employees
) AS ranked               
WHERE Ranked_Salary <= 2
ORDER BY dept_id, Ranked_Salary;  