USE hr_analytics_project;

-- PART A: Get a brief overview of our data in the Tables within the Database
-- Authorise the DB to allow data manipulation
SET sql_safe_updates = 0;

-- Get a brief overview of our data
SELECT * FROM human resources;

-- Rename table name to render it readable in MySQL
RENAME TABLE `human resources` TO human_resource;

-- Obtain a brief overview of our data
SELECT * FROM human_resource;

-- Obtain an overview of the fields data types
DESCRIBE human_resource;

-- PART B. DATA CLEANING PROCEDURES (Rename fields and change data types for uniformity purposes)
-- Rename the first colum to employee_id
ALTER TABLE human_resource
RENAME COLUMN ï»¿id TO employee_id;

-- Specify the data type for the newly renamed column
ALTER TABLE human_resource
MODIFY COLUMN employee_id VARCHAR(30) NULL;

-- Modify the date colummns from text to date and of format "Year-Month-Day"
-- For birthdate column
UPDATE human_resource
SET birthdate =
	CASE WHEN birthdate LIKE '%/%' THEN date_format(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
		WHEN birthdate LIKE '%-%' THEN date_format(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE NULL
END;

-- Update the birthdate column data type
ALTER TABLE human_resource
MODIFY COLUMN birthdate DATE;


-- For hire_date column
UPDATE human_resource
SET hire_date =
	CASE WHEN hire_date LIKE '%/%' THEN date_format(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
		WHEN hire_date LIKE '%-%' THEN date_format(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE NULL
END;

-- Update hire_date column data type to DATE
ALTER TABLE human_resource
MODIFY COLUMN hire_date DATE;

-- For the termdate column strip off the UTC in date format
UPDATE human_resource
SET termdate = STR_TO_DATE(termdate,'%Y-%m-%d-%H-%i-%s UTC')
WHERE termdate is NULL AND termdate !='';

-- Update the termdate column to DATE data type
ALTER TABLE human_resource
MODIFY COLUMN termdate DATE;

-- Update the NULLS in the termdate column to contain a date value of 2026-03-21
-- The termdate 2026-03-21 implies that the employees are still employed at the company and haven't yet been terminated.
UPDATE human_resource
SET termdate = '2026-03-21'
WHERE termdate IS NULL;

-- View data once again
SELECT * FROM human_resource;
DESCRIBE human_resource;

-- PART C : Exploratory Data Analysis
-- Add another column to the data (Age)
ALTER TABLE human_resource
ADD COLUMN employee_age INT NOT NULL;

-- Calculate individual employee ages
UPDATE human_resource
SET employee_age = timestampdiff(Year, birthdate, CURDATE());

-- Describe to see if changes have been effected
SELECT birthdate, employee_age FROM human_resource;

-- Calculate the minimum and maximum ages from our data
SELECT 
	MAX(employee_age) AS Old_employee,
    MIN(employee_age) AS Young_employee
FROM human_resource;

-- Get rid of outliers in employee age. Define only Ages greater than 18 are allowed
SELECT COUNT(*) FROM human_resource
WHERE employee_age < 18;

-- PART D; ANSWER BUSINESS QUESTIONS
-- What is the gender breakdown of employees at the company?
SELECT gender, COUNT(*) AS Gender_count
FROM human_resource
WHERE employee_age >=18
AND termdate = '2026-03-21'
GROUP BY gender;

-- What is the race breakdown of the employees at the company?
SELECT race, COUNT(*) AS race_count
FROM human_resource 
WHERE employee_age >= 18 AND termdate = '2026-03-21'
GROUP BY race
ORDER BY race_count DESC;

-- What is the age distribution of employees at the company?
SELECT 
	MAX(employee_age) AS Old_employee,
    MIN(employee_age) AS Young_employee
FROM human_resource 
WHERE employee_age >=18;

-- Let us create age bracket groups for our data
SELECT 
	CASE WHEN employee_age BETWEEN 18 AND 25 THEN 'New_generation'
		WHEN employee_age BETWEEN 26 AND 40 THEN 'Mid_generation'
        WHEN employee_age BETWEEN 41 AND 60 THEN 'Old_generation'
        ELSE 'Retired_generation'
	END AS age_group_category,
COUNT(*) AS COUNT FROM human_resource
WHERE employee_age >=18 
GROUP BY age_group_category
ORDER BY age_group_category DESC;

-- How many employees work at the Headquarters versus those at Remote location
SELECT location, COUNT(*) AS location_count
FROM human_resource
WHERE employee_age >=18
GROUP BY location;
 
 -- How does the gender distribution vary across departments
 SELECT gender, department, COUNT(*) department
 FROM human_resource
 WHERE employee_age >=18
 GROUP BY department, gender
 ORDER BY department DESC;
 
 -- What is the distribution of job titles at the company
 SELECT jobtitle, COUNT(*) AS job_title_count FROM human_resource
 WHERE employee_age >=18
 GROUP BY jobtitle;
 
 -- Which department has the highest turn over rate at the company?
 SELECT department, department_count, terminated_count,
		terminated_count / department_count AS termination_rate
FROM (
 SELECT department,
		COUNT(*) AS department_count,
	SUM(CASE
			WHEN termdate <= '2026-03-21' THEN 1 
            ELSE 0
		END) AS terminated_count
	FROM human_resource
    WHERE employee_age >= 18
    GROUP BY department
    ) AS subquery
    ORDER BY termination_rate DESC;
    
-- What is the distribution of employees across locations by city and state
SELECT location_state, location_city, COUNT(*) AS location_count
FROM human_resource
WHERE employee_age >=18
GROUP BY location_state, location_city
ORDER BY location_count DESC;
    
 
