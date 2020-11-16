-- Creating tables for PH-Employess DB
CREATE TABLE departments(
	dept_no VARCHAR(4) NOT NULL,
	dept_name VARCHAR(40) NOT NULL, 
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE employees (
	emp_no INT NOT NULL,
	birth_date VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),	
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no)
);

CREATE TABLE dept_employee(
	emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE title (
	emp_no INT NOT NULL,
	title VARCHAR (20) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--Create new table for retirement
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

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
	AND (de.to_date = '9999-01-01');
	
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


--CHALLENGE
-- NUMBER OF RETIRING EMPLOYEES
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO retirement_titles
FROM employees AS e
	INNER JOIN title AS ti
	ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- UNIQUE TITLES FOR RETIRING EMPLOYEES
SELECT DISTINCT ON(emp_no)
	emp_no,
	first_name,
	last_name,
	title
--INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC,
	to_date DESC;

--COUNT RETIRING EMPLOYEES BY TITLE
SELECT COUNT (ut.title), ut.title
--INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC; 	

-- MENTORSHIP PROGRAM
SELECT DISTINCT ON (emp_no) 
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
--INTO membership_eligibility
FROM employees AS e
INNER JOIN dept_employee AS de
ON e.emp_no = de.emp_no
INNER JOIN title AS ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no ASC;


--ADDITIONAL ANALYSIS
--MODIFIED MENTORSHIP LIST
SELECT DISTINCT ON (emp_no) 
	e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	ti.title
--INTO modified_membership_eligibility
FROM employees AS e
INNER JOIN dept_employee AS de
ON e.emp_no = de.emp_no
INNER JOIN title AS ti
ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1962-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no ASC;

-- NUMBER OF RETIRING EMPLOYEES IN PHASE TWO
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	ti.to_date
INTO modified_retirement_titles
FROM employees AS e
	INNER JOIN title AS ti
	ON e.emp_no = ti.emp_no
WHERE (e.birth_date BETWEEN '1956-01-01' AND '1960-12-31')
ORDER BY e.emp_no;

-- UNIQUE TITLES FOR RETIRING EMPLOYEES PHASE TWO
SELECT DISTINCT ON(emp_no)
	emp_no,
	first_name,
	last_name,
	title
--INTO unique_titles_phase_two
FROM modified_retirement_titles
ORDER BY emp_no ASC,
	to_date DESC;

