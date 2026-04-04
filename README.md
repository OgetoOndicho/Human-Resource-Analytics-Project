# Broadway Inc (HR-ANALYTICS) Project
This project analyzes employee data using MySQL to generate insights that will enable stakeholders at Broadway Human Resource with decision-making processes. The dataset includes important employee metrics such as age, gender, demographics, job titles, departmental titles, termination records, and geographic distribution. Broadway company stakeholders would love some Key questions answered through a comprehensive report.

## Business Objectives;
- Perform comprehensive cleaning,  transformation and analysis on the Human Resource data.
- Conduct Exploratory Data Analysis (EDA) on the data to help answer questions.
- Deliver a thorough and up to date  report using a BI Tool.
- Identify key metrics and performance indicators to enable the company to track in the longterm.

## Business Questions
- Discover which are some the most dominant ethnicities employed by the company
- Find the age distribution of employees at the company. What is the maximum and minimum ages of employees at the company?
- What is the distribution of employees across locations' city or state/
- How does gender distribution vary across the departmets
- Which department has the highest turnover rates?
- What is the tenure distribution for each department?

## Mandatory deliverable Metrics
- Age distribution of employees: Involved grouping criterion for employees aged 18 and above (≥ 18 years)
- Gender breakdown of employees: Are females the majority? Are the males the mjority?
- Termination Rate Analysis: Calculated the average length of employment before an employee is terminated?
- Turnover Rates: Which department has the highest turnover rate? What could be some of the most probable reasons for it?

## Tools Used
1. MySQL: For data exploration, cleaning and manipulation'
2. PowerBI: For visualization and reporting.


## Topic Covered
- Updating tables, renaminng columns and adjusting data types
- Data Cleaning by removing duplicates and NULLS
- Grouping, filyering and Sorting data.
- Date formatting

## Results and Findings
- How are the ages of employees by the company distributed?
```sql
SELECT 
	MAX(employee_age) AS Old_employee,
    MIN(employee_age) AS Young_employee
FROM human_resource
WHERE employee_age >= 18;
```
From the result obtained, the Oldest employee at the company is aged 60 years while the youngest employee is aged 23 years.


- What is the gender breakdown of employees at the company?
```sql
SELECT gender, COUNT(*) AS Gender_count
FROM human_resource
WHERE employee_age >=18
AND termdate = '2026-03-21'
GROUP BY gender;
```
As of the termination date of some of employees Dated 2026-03-21, there were a total of 8911 Males, 8090 Females and 481 of the non conforming at the company.


- What is the race breakdown of the employees at the company?
```sql
SELECT race, COUNT(*) AS race_count
FROM human_resource 
WHERE employee_age >= 18 AND termdate = '2026-03-21'
GROUP BY race
ORDER BY race_count DESC;
```
This code identifis employees aged over 18 years and at termination dated 2026-03-21, there were a total of 7 races at the company. The Whites comprised the majority with 4,987 employed while the Native Hawaiian or Other Pacific Islander were the minority at just 952.

- How are the employees distributed across the Company's Locations?
```sql
SELECT location, COUNT(*) AS location_count
FROM human_resource
WHERE employee_age >=18
GROUP BY location;
```
The company's employees work either at the Headquarters or Remotely. From the findings, employees reporting to the headquarters formed the majority at 15,992 while those who operated remotely were at just 5,255.

 - Which department has the highest turn over rate at the company?
Turnover rate simply means the rate at which employees leave the company where they work before their contract comes to an end
```sql
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
```
The Training, Marketing and Auditing departments  recorded the highest turnover rate of employees at 0.96% while Research and Development Company department had the least turnoverrate at 0.92%

- What is the Average length of employment at the company for those employees who have been terminated?
```sql
SELECT
	AVG(datediff(termdate, hire_date)) / 365 AS avg_employment_length
FROM human_resource
WHERE termdate = '2026-03-21'
AND employee_age >=18;
```
From the findings, as of the date 2026-03-21, the employees terminated had been with the company for close to 15 years.







