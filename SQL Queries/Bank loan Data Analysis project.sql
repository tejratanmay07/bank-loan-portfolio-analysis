
-- =========================================== PROJECT: Bank Loan Data Analysis ===================================================== --
-- AUTHOR: Tanmay Tejra
-- DATE: 20-04-2026
-- DESCRIPTION: SQL queries to extract KPIs and insights for the Bank Loan Report.
-- ================================================================================================================================== --

-- Step 1: Select the database
USE financial_db;


-- ------------------------------------ SECTION A.1: KEY PERFORMANCE INDICATORS (KPIs)------------------------------------------------ --

-- 1. Number of Applications -----------------------------------------------------------

-- Total Loan Applications
SELECT COUNT(id) AS Total_Loan_Applications
FROM financial_loan;

-- MTD (Month-To-Date) Loan Applications
SELECT COUNT(*) 
FROM financial_loan
# WE HAVE TAKEN 12TH MONTH IN MTD QUESTIONS BECAUSE IT'S THE LATEST DATE IN DATABASE.
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;

-- PMTD Loan Applications(Previous Month)

SELECT COUNT(*)
FROM financial_loan
# WE HAVE TAKEN 11TH MONTH IN PMTD QUESTIONS BECAUSE WE HAVE TAKEN 12TH MONTH AS CURRENT MONTH.
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date) = 2021;

-- 2. Funded Amount (Total Loan Amount approved) ----------------------------------------

-- Total Funded Amount
SELECT SUM(loan_amount) as total_funded_amount
FROM financial_loan;

-- MTD Total Funded Amount
SELECT SUM(loan_amount) as MTD_funded_amount
FROM financial_loan
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;

-- PMTD Total Funded Amount
SELECT SUM(loan_amount) as PMTD_funded_amount
FROM financial_loan
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date)=2021;

-- 3. Amount Received(Loan Amount paid) --------------------------------------------------

-- Total Amount Received
SELECT SUM(total_payment) as total_amount_received
FROM financial_loan;

-- MTD Total Amount Received
SELECT SUM(total_payment) as MTDtotal_amount_received
FROM financial_loan
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;

-- PMTD Total Amount Received
SELECT SUM(total_payment) as PMTDtotal_amount_received
FROM financial_loan
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date)=2021;

-- 4. Interest Rate ----------------------------------------------------------------------

-- Average Interest Rate
#  Calculates the overall average interest rate as a percentage.
SELECT AVG(int_rate)*100 as Average_interest
FROM financial_loan;

-- MTD Average Interest
SELECT AVG(int_rate)*100 as MTDAverage_interest
FROM financial_loan
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;

-- PMTD Average Interest
SELECT AVG(int_rate)*100 as MTDAverage_interest
FROM financial_loan
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date)=2021;

-- 5.DTI (Debt to Income ratio) -----------------------------------------------------------

-- Avg DTI
# Calculates the overall average DTI rate as a percentage.
SELECT AVG(dti)*100 AS Avg_dti 
FROM financial_loan;

-- MTD Avg DTI
SELECT AVG(dti)*100 AS MTDAvg_dti
FROM financial_loan
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021;

-- PMTD Avg DTI
SELECT AVG(dti)*100 AS PMTDAvg_dti
FROM financial_loan
WHERE MONTH(issue_date) = 11
AND YEAR(issue_date)=2021;


-- ------------------------------------------------ SECTION A.2: GOOD LOAN ISSUED --------------------------------------------------- --

-- 1. Good Loan Percentage ----------------------------------------------------------------
# Calculates the percentage of loans that are 'Fully Paid' or 'Current'.
# Here we used subquery to solve this question. Firstly we find the total good applications and then find the percentage.

SELECT( 
       SELECT COUNT(id) AS Good_loan_applications 
       FROM financial_loan
       WHERE loan_status IN ('FULLY PAID','CURRENT')
	  ) 
       /COUNT(ID)*100 as Good_Loan_Percentage
FROM financial_loan;

-- 2. Good Loan Applications 

SELECT COUNT(id) AS Good_loan_applications 
FROM financial_loan
WHERE loan_status IN ('FULLY PAID','CURRENT') ;

-- 3. Good Loan Funded Amount 

SELECT SUM(loan_amount) AS Good_funded_amount
FROM financial_loan
WHERE loan_status IN ('FULLY PAID','CURRENT');

-- 4. Good Loan Amount Received 

SELECT SUM(total_payment) AS Good_loan_amount_received
FROM financial_loan
WHERE loan_status IN ('FULLY PAID','CURRENT');


-- ------------------------------------------------ SECTION A.3: BAD LOAN ISSUED --------------------------------------------------- --

-- 1. BAD Loan Percentage ----------------------------------------------------------------
# Calculates the percentage of loans that are 'Charged off'.
# Here we used subquery to solve this question. Firstly we find the total good applications and then find the percentage.

SELECT( 
       SELECT COUNT(id) AS Bad_loan_applications 
       FROM financial_loan
       WHERE loan_status IN ('Charged off')
	  ) 
       /COUNT(ID)*100 as Bad_Loan_Percentage
FROM financial_loan;

-- 2. Good Loan Applications 

SELECT COUNT(id) AS Bad_loan_applications 
FROM financial_loan
WHERE loan_status IN ('Charged off') ;

-- 3. Bad Loan Funded Amount 

SELECT SUM(loan_amount) AS Bad_funded_amount
FROM financial_loan
WHERE loan_status IN ('Charged off');

-- 4. Bad Loan Amount Received.

SELECT SUM(total_payment) AS Bad_loan_amount_received
FROM financial_loan
WHERE loan_status IN ('Charged off');


-- ----------------------------------------------- SECTION A.4:LOAN STATUS SUMMARY -------------------------------------------------- --

-- Complete Loan Status Summary. 

SELECT loan_status,
COUNT(*) AS applications,
SUM(loan_amount) AS funded,
SUM(total_payment) AS received
FROM financial_loan
GROUP BY loan_status;

-- MTD Loan Status Summary. 
# WE HAVE TAKEN 12TH MONTH IN MTD QUESTIONS BECAUSE IT'S THE LATEST DATE IN DATABASE.
SELECT loan_status,
COUNT(*) AS applications,
SUM(loan_amount) AS funded,
SUM(total_payment) AS received
FROM financial_loan
WHERE MONTH(issue_date) = 12
AND YEAR(issue_date) = 2021
GROUP BY loan_status;


-- --------------------------------------------- B.1: BANK LOAN REPORT | OVERVIEW --------------------------------------------------- --

-- A. MONTH 
# This will showcase how 'Total Loan Applications,' 'Total Funded Amount,' and 'Total Amount Received' vary over time.
SELECT 
MONTH(issue_date) AS Month,
COUNT(*) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY MONTH(issue_date)
ORDER BY month;

-- B. STATE
# This will represent lending metrics categorized by state.
SELECT address_state AS STATE,
COUNT(*) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY address_state
ORDER BY address_state;

-- C. TERM
# This will depict loan statistics based on different loan terms.Loan Terms (e.g., 36 months, 60 months)
SELECT term AS TERM,
COUNT(*) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY TERM;

-- D. EMPLOYEE LENGTH
# This will illustrate how lending metrics are distributed among borrowers with different employment lengths.
SELECT Emp_length AS EMPLOYEE_LENGTH,
COUNT(*) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length;

-- E. PURPOSE 
# This will provide a breakdown of loan metrics based on the stated purposes of loans.
SELECT purpose AS PURPOSE,
COUNT(*) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY purpose
ORDER BY purpose;

-- F. HOME OWNERSHIP
# Hierarchy: Home Ownership Categories (e.g., own, rent, mortgage)
SELECT home_ownership,
COUNT(*) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Received_Amount
FROM financial_loan
GROUP BY home_ownership
ORDER BY home_ownership;


-- ------------------------------------------------C. Miscellaneous | OVERVIEW-------------------------------------------------------- --

-- 1. MoM Loan Application growth rate
# Calculates the percentage increase or decrease in applications from November to December.
WITH MTD_Data AS (
    SELECT COUNT(id) AS MTD_Apps
    FROM financial_loan 
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_Data AS (
    SELECT COUNT(id) AS PMTD_Apps
    FROM financial_loan 
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT 
    ROUND(((MTD_Apps - PMTD_Apps) / PMTD_Apps) * 100, 2) AS MoM_Application_Growthrate
FROM MTD_Data, PMTD_Data;

 -- 2. Mom Loan Amount Disbursed growth rate
 # Calculates the percentage increase or decrease in total funded amounts from Nov to Dec.
 WITH MTD_Data AS (
    SELECT SUM(loan_amount) AS MTD_Funded 
    FROM financial_loan 
    WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021
),
PMTD_Data AS (
    SELECT SUM(loan_amount) AS PMTD_Funded 
    FROM financial_loan 
    WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021
)
SELECT 
    ROUND(((MTD_Funded - PMTD_Funded) / PMTD_Funded) * 100, 2) AS MoM_Funded_Amount_Growth_Pct
FROM MTD_Data, PMTD_Data;

-- 3. Interest rate for various subgrade and grade loan type.
# Evaluates the risk premium by observing how interest rates scale across different loan grades.
SELECT 
    grade AS Loan_Grade, 
    sub_grade AS Loan_Sub_Grade, 
    ROUND(AVG(int_rate) * 100, 2) AS Average_Interest_Rate_Pct
FROM financial_loan
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;

select *
from financial_loan;
-- ======================================================================================================================================
