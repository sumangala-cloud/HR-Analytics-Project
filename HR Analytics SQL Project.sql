Create Database HR_Analytics ;
Use HR_Analytics ;

Select * from HR_Data ;
desc HR_Data ;

#----------To_Check_total_records------------------#
 
SELECT COUNT(*) AS Total_Rows 
FROM HR_Data ;

#--------To_Check_the_DataType------------#

DESC HR_Data ;

#--------------------------To_Check_the_Null_values-------------------------------#

SELECT * From hr_null_validation ;		-- run this view

(CREATE VIEW hr_null_validation AS	-- to show the syntax for view
SELECT
    COUNT(*) AS Total_Records,

    SUM(CASE WHEN `Employee ID` IS NULL THEN 1 ELSE 0 END) AS EmployeeID_NULL,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_NULL,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS Attrition_NULL,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_NULL,
    SUM(CASE WHEN MaritalStatus IS NULL THEN 1 ELSE 0 END) AS MaritalStatus_NULL,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Department_NULL,
    SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS JobRole_NULL,
    SUM(CASE WHEN BusinessTravel IS NULL THEN 1 ELSE 0 END) AS BusinessTravel_NULL,
    SUM(CASE WHEN DistanceFromHome IS NULL THEN 1 ELSE 0 END) AS DistanceFromHome_NULL,
    SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS Education_NULL,
    SUM(CASE WHEN EducationField IS NULL THEN 1 ELSE 0 END) AS EducationField_NULL,
    SUM(CASE WHEN JobLevel IS NULL THEN 1 ELSE 0 END) AS JobLevel_NULL,
    SUM(CASE WHEN JobInvolvement IS NULL THEN 1 ELSE 0 END) AS JobInvolvement_NULL,
    SUM(CASE WHEN JobSatisfaction IS NULL THEN 1 ELSE 0 END) AS JobSatisfaction_NULL,
    SUM(CASE WHEN EnvironmentSatisfaction IS NULL THEN 1 ELSE 0 END) AS EnvironmentSatisfaction_NULL,
    SUM(CASE WHEN RelationshipSatisfaction IS NULL THEN 1 ELSE 0 END) AS RelationshipSatisfaction_NULL,
    SUM(CASE WHEN WorkLifeBalance IS NULL THEN 1 ELSE 0 END) AS WorkLifeBalance_NULL,
    SUM(CASE WHEN DailyRate IS NULL THEN 1 ELSE 0 END) AS DailyRate_NULL,
    SUM(CASE WHEN HourlyRate IS NULL THEN 1 ELSE 0 END) AS HourlyRate_NULL,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS MonthlyIncome_NULL,
    SUM(CASE WHEN MonthlyRate IS NULL THEN 1 ELSE 0 END) AS MonthlyRate_NULL,
    SUM(CASE WHEN PercentSalaryHike IS NULL THEN 1 ELSE 0 END) AS PercentSalaryHike_NULL,
    SUM(CASE WHEN PerformanceRating IS NULL THEN 1 ELSE 0 END) AS PerformanceRating_NULL,
    SUM(CASE WHEN StockOptionLevel IS NULL THEN 1 ELSE 0 END) AS StockOptionLevel_NULL,
    SUM(CASE WHEN NumCompaniesWorked IS NULL THEN 1 ELSE 0 END) AS NumCompaniesWorked_NULL,
    SUM(CASE WHEN TotalWorkingYears IS NULL THEN 1 ELSE 0 END) AS TotalWorkingYears_NULL,
    SUM(CASE WHEN YearsAtCompany IS NULL THEN 1 ELSE 0 END) AS YearsAtCompany_NULL,
    SUM(CASE WHEN YearsInCurrentRole IS NULL THEN 1 ELSE 0 END) AS YearsInCurrentRole_NULL,
    SUM(CASE WHEN YearsSinceLastPromotion IS NULL THEN 1 ELSE 0 END) AS YearsSinceLastPromotion_NULL,
    SUM(CASE WHEN YearsWithCurrManager IS NULL THEN 1 ELSE 0 END) AS YearsWithCurrManager_NULL,
    SUM(CASE WHEN TrainingTimesLastYear IS NULL THEN 1 ELSE 0 END) AS TrainingTimesLastYear_NULL,
    SUM(CASE WHEN OverTime IS NULL THEN 1 ELSE 0 END) AS OverTime_NULL

FROM hr_data;)

#-------To_Check_the_Duplicate_EmpID---------#

SELECT
	  `Employee ID`,
	  COUNT(*) AS duplicate_count
      FROM HR_Data
      GROUP BY `Employee ID`
      HAVING COUNT(*)>1 ;


#-----------KPI-Related_Categorical_Data_Validation--------------# 
    
SELECT DISTINCT Attrition FROM hr_data;
SELECT DISTINCT Department FROM hr_data;
SELECT DISTINCT Gender FROM hr_data;
SELECT DISTINCT JobRole FROM hr_data;
SELECT DISTINCT WorkLifeBalance FROM hr_data;

#----------Check_the_Numerical_Values---------#

SELECT HourlyRate, 
       MonthlyIncome, 
	   TotalWorkingYears,
       WorkLifeBalance, 
	   YearsSinceLastPromotion
FROM HR_Data
WHERE HourlyRate < 0
   OR MonthlyIncome < 0
   OR TotalWorkingYears < 0
   OR WorkLifeBalance < 0
   OR YearsSinceLastPromotion < 0 ;
   
   
#----------Check_the_Format----=-----#

SELECT Gender, Department, JobRole, MaritalStatus, EducationField
FROM hr_data
WHERE Gender <> TRIM(Gender)
   OR Department <> TRIM(Department)
   OR JobRole <> TRIM(JobRole)
   OR MaritalStatus <> TRIM(MaritalStatus)
   OR EducationField <> TRIM(EducationField);
   
#----------------KPI_Analysis--------------#
   
#1--------------Average Attrition rate for all Departments-------------#

SELECT Department, Total_Employees, Employees_Left,
Employees_Left/Total_Employees*100 as Attrition_Rate
FROM ( SELECT Department ,count(*) as Total_Employees,
sum( CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) as Employees_Left 
FROM hr_data
GROUP BY Department) as Department_Data;

#2--------------Average Hourly rate of Male Research Scientist-------------#

SELECT
    ROUND(AVG(HourlyRate), 2) AS Average_Hourly_Rate
FROM HR_Data
WHERE Gender = 'Male'
  AND JobRole = 'Research Scientist';

#3--------------Attrition rate Vs Monthly income stats-------------#

SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Below 3000'
        WHEN MonthlyIncome BETWEEN 3000 AND 5999 THEN '3000-5999'
        WHEN MonthlyIncome BETWEEN 6000 AND 9999 THEN '6000-9999'
        ELSE '10000 & Above'
    END AS Income_Band,
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Attrition_Count,
    ROUND(
        100.0 * SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Attrition_Rate
FROM HR_Data
GROUP BY
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Below 3000'
        WHEN MonthlyIncome BETWEEN 3000 AND 5999 THEN '3000-5999'
        WHEN MonthlyIncome BETWEEN 6000 AND 9999 THEN '6000-9999'
        ELSE '10000 & Above'
	END
ORDER BY MIN(MonthlyIncome);

#4--------------Average Working Years for each Department-------------#

SELECT
Department,
ROUND(AVG(TotalWorkingYears), 2) AS Avg_Working_Years
FROM hr_data
GROUP BY Department;

#5--------------Job Role vs Work Life Balance-------------#

SELECT JobRole, COUNT(*) AS Total_Employees,
ROUND(AVG(WorkLifeBalance), 2) AS Work_Life_Balance
FROM hr_data
GROUP by JobRole
ORDER BY Work_Life_Balance DESC;

#6--------------Attrition rate Vs Year since last promotion relation------------#

SELECT
    YearsSinceLastPromotion,
    COUNT(*) AS Total_Employees,
    SUM(CASE
        WHEN Attrition = 'Yes' THEN 1
        ELSE 0 END) AS Attrition_Count,
    ROUND(SUM(CASE
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0 END) * 100.0 / COUNT(*),2) AS Attrition_Rate
FROM hr_data
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;