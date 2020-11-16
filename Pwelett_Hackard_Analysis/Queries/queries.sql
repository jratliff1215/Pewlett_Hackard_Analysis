-- Joining departments and dept_manager tables
SELECT d.dept_name,
	dm.emp_no,
	dm.to_date,
	dm.from_date
FROM departments AS d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--Joining retirement_info to dept_emp tables
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_employee as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');



--Employee count by department number
SELECT COUNT (ce.emp_no), de.dept_no
INTO by_dept
FROM current_emp AS ce
LEFT JOIN dept_employee as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Employee to salary join
SELECT * FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no, 
	e.first_name, 
e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_employee AS de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1955-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	AND (de.to_date = '9999-01-01')
	
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
		
-- List of Department Employees
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_employee AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- List of sales retirement
SELECT  ri.emp_no,
        ri.first_name,
        ri.last_name,
		d.dept_name
INTO sales_retirement
FROM dept_employee AS de
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
    INNER JOIN retirement_info AS ri
        ON (de.emp_no = ri.emp_no)
	WHERE d.dept_name IN ('Sales');

-- List of sales  and development retirement
SELECT  ri.emp_no,
        ri.first_name,
        ri.last_name,
		d.dept_name
INTO sales_development_retirement
FROM dept_employee AS de
    INNER JOIN departments AS d
        ON (de.dept_no = d.dept_no)
    INNER JOIN retirement_info AS ri
        ON (de.emp_no = ri.emp_no)
	WHERE d.dept_name IN ('Sales', 'Development');