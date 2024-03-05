# World Life Expectancy Project (Exploratory Data Analysis)

-- Taking a look at the data
SELECT *
FROM world_life_expectancy
;

-- Looking at the MIN and MAX life expectancy and seeing how much it has changed over 15 years
SELECT Country, 
MIN(`Life Expectancy`), 
MAX(`Life Expectancy`),
ROUND(MAX(`Life Expectancy`) - MIN(`Life Expectancy`),1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING  MIN(`Life Expectancy`) <> 0
AND MAX(`Life Expectancy`) <> 0
ORDER BY Life_Increase_15_Years DESC
;

-- Taking a look at the Global Life Expectancy per Year
SELECT Year, 
ROUND(AVG(`Life Expectancy`),2) AS Average_Life_Expectancy
FROM world_life_expectancy
WHERE `Life Expectancy` <> 0
GROUP BY Year
ORDER BY Year
;

-- Looking at the Life Expectancy against the GDP by Country
SELECT Country, 
ROUND(AVG(`Life Expectancy`),1) AS Life_Exp, 
ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND GDP > 0
ORDER BY GDP DESC
;

-- Using a CASE statement to identify how High GDP and Low GDP correlate to Life Expectancy
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life Expectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life Expectancy` ELSE NULL END) Low_GDP_Life_Expectancy
FROM world_life_expectancy
;

-- Looking at the Life Expectancy depending on the Status of all Countries and seeing how many total Countries there are per Status
SELECT Status, 
COUNT(DISTINCT Country), 
ROUND(AVG(`Life Expectancy`),1)
FROM world_life_expectancy
GROUP BY Status
;

-- Looking at the Average Life Expectancy VS Average BMI for each Country over 15 Years
SELECT Country, 
ROUND(AVG(`Life Expectancy`),1) AS Life_Exp, 
ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Exp > 0
AND BMI > 0
ORDER BY BMI DESC
;

-- Using a Rolling total to calculate the total amount of Adult Mortality per Country
SELECT Country, 
Year, 
`Life Expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER (PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
-- WHERE Country LIKE '%United%'
;