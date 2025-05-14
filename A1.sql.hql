--Before creating the table, need to upload the csv file from the local to HDFS.
--This time I used scp in cmd to upload.
-- creat table
CREATE EXTERNAL TABLE international_education_costs (
    Country STRING,
    City STRING,
    University STRING,
    Program STRING,
    Level STRING,
    Duration_Years INT,
    Tuition_USD DOUBLE,
    Living_Cost_Index DOUBLE,
    Rent_USD DOUBLE,
    Visa_Fee_USD DOUBLE,
    Insurance_USD DOUBLE,
    Exchange_Rate DOUBLE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/maria_dev/input/'
TBLPROPERTIES ("skip.header.line.count"="1");

--I usually check whether the table I am verifying is an empty table.
SELECT * FROM international_education_costs LIMIT 15;

-- According to the national average tuition fees statistics
SELECT
  Country,
  ROUND(AVG(Tuition_USD), 2) AS Avg_Tuition_USD
FROM international_education_costs
GROUP BY Country;

-- The total cost of each country or region
SELECT
  Country,
  ROUND(AVG(Tuition_USD + Rent_USD * 12 * Duration_Years + Insurance_USD + Visa_Fee_USD), 2) AS Avg_Total_Cost_USD
FROM international_education_costs
GROUP BY Country;

-- Cost of Living Index Distribution
SELECT
  Country,
  ROUND(AVG(Living_Cost_Index), 2) AS Avg_Living_Cost_Index
FROM international_education_costs
GROUP BY Country;

-- Statistical analysis of the average tuition fees in various countries by program.
SELECT
  Country,
  Program,
  ROUND(AVG(Tuition_USD), 2) AS Avg_Tuition_By_Program
FROM international_education_costs
GROUP BY Country, Program;

--Average spending in each country by degree level
SELECT
  Level,
  ROUND(AVG(Tuition_USD), 2) AS avg_tuition_usd,
  ROUND(AVG(Rent_USD + Living_Cost_Index * 20 + Tuition_USD + Visa_Fee_USD + Insurance_USD), 2) AS avg_total_cost_usd,
  ROUND(AVG(Living_Cost_Index), 2) AS avg_living_cost_index
FROM international_education_costs
GROUP BY Level;
