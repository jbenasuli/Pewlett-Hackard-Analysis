-- Creating queries for PH-EmployeeDB
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-- results returned above - 90398 rows affected.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
-- results returned above - 21209 rows affected.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
-- results returned above - 22857 rows affected.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
-- results returned above - 23228 rows affected.
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
-- results returned above - 23104 rows affected.
-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Number of employees retiring table creation
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- viewing newly created table
SELECT * FROM retirement_info;
-- Dropping retirment info to recreate new version
DROP TABLE retirement_info;
-- Create new table for retiring employees which includes emp_no column
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;
-- Joining departments and dept_manager tables - updated with aliases
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;
-- Joining retirement_info and dept_emp tables
SELECT  retirement_info.emp_no,
    retirement_info.first_name,
    retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;
-- Joining retirement_info and dept_emp tables with aliases
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;
-- Use Left Join for retirement_info and dept_emp tables to create current_emp table
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;
-- Employee count by department number - ordered
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- Employee count by department number - ordered - into table
SELECT COUNT(ce.emp_no), de.dept_no
INTO current_emp_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
-- validating salaries.to_date data
SELECT * FROM salaries;
SELECT * FROM salaries
ORDER BY to_date DESC;
-- drafting new temporary table (emp_info)
SELECT emp_no,
    first_name,
    last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31'); 
-- creating new table with additional columns, aliases and joins
SELECT e.emp_no,
    e.first_name,
    e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (de.to_date = '9999-01-01');
-- confirming successful table creating before csv export
SELECT * FROM emp_info;
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
-- confirming successful table creating before csv export
SELECT * FROM manager_info;
-- updating the current_emp table to also include a list of departments
SELECT ce.emp_no,
    ce.first_name,
    ce.last_name,
    d.dept_name
INTO dept_info
FROM current_emp as ce
    INNER JOIN dept_emp AS de
        ON (ce.emp_no = de.emp_no)
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no);
-- confirming successful table creating before csv export
SELECT * FROM dept_info;
-- creating new sales team retirement table by querying the new dept_info table
SELECT *
INTO dept_info_sales
FROM dept_info
WHERE dept_name = 'Sales';
-- confirming count of 5860 records previously generated in current_emp_dept table 
SELECT * FROM dept_info_sales;
-- creating new table to include both the sales and development teams
SELECT *
INTO dept_info_sales_development
FROM dept_info
WHERE dept_name IN ('Sales', 'Development');
-- confirming total count of 15141 from records previously generated in current_emp_dept table 
SELECT * FROM dept_info_sales_development;