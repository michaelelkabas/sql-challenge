-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/IN5CRU
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "departments" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "dept_name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR(10)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" VARCHAR(50)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" VARCHAR(50)   NOT NULL,
    "last_name" VARCHAR(50)   NOT NULL,
    "sex" VARCHAR(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" money   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(50)   NOT NULL,
    "title" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--- List the employee number, last name, first name, sex, and salary of each employee.

SELECT e.emp_no,
       e.last_name,
       e.first_name,
       e.sex,
       s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no;

--- List the first name, last name, and hire date for the employees who were hired in 1986
SELECT first_name,
       last_name,
       hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) = 1986;

--- List the manager of each department along with their department number, 
--- department name, employee number, last name, and first name

SELECT dm.dept_no,
       d.dept_name,
       dm.emp_no AS manager_emp_no,
       e.last_name AS manager_last_name,
       e.first_name AS manager_first_name
FROM dept_manager dm
JOIN departments d ON dm.dept_no = d.dept_no
JOIN employees e ON dm.emp_no = e.emp_no;

--- List the department number for each employee along with that employee’s employee number, 
--- last name, first name, and department name

SELECT de.emp_no,
       e.last_name,
       e.first_name,
       de.dept_no,
       d.dept_name
FROM dept_emp de
JOIN employees e ON de.emp_no = e.emp_no
JOIN departments d ON de.dept_no = d.dept_no;

--- List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the 
--- letter B.

SELECT first_name,
       last_name,
       sex
FROM employees
WHERE first_name = 'Hercules'
  AND last_name LIKE 'B%';

--- List each employee in the Sales department, including their employee number, last name, 
--- and first name.

SELECT e.emp_no,
       e.last_name,
       e.first_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

--- List each employee in the Sales and Development departments, including their employee number, last name, 
--- first name, and department name.

SELECT e.emp_no,
       e.last_name,
       e.first_name,
       d.dept_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

--- List the frequency counts, in descending order, of all the employee last names 
--- (that is, how many employees share each last name).

SELECT last_name,
       COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;
