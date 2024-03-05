# World Life Expectancy Project (Data Cleaning)


-- Taking a look at our data
SELECT * 
FROM world_life_expectancy
;

-- Identifying where there are duplicates of Countries and Years
SELECT Country, 
Year, 
Concat(Country, Year), 
COUNT(Concat(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(Concat(Country, Year)) > 1
;

-- Identifying which rows are duplicated
SELECT *
FROM (
	SELECT Row_ID, 
	Concat(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY Concat(Country, Year) ORDER BY Concat(Country, Year		)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num > 1
;

-- Deleting the duplicated rows
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID, 
	Concat(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY Concat(Country, Year) ORDER BY Concat(Country, Year		)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_Table
WHERE Row_Num > 1
	)
;

-- Identifying blank rows for the Status Column
SELECT * 
FROM world_life_expectancy
WHERE Status = ''
;

-- Identifying what should be populated in the rows for the Status Column
SELECT DISTINCT(Status) 
FROM world_life_expectancy
WHERE Status <> ''
;

-- Identifying all of the countries which are 'Developing'
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

-- Using a self join and updating our 'world_life_expectancy' table and setting the blank Status rows to 'Developing' where the Countries already have a status of 'Developing' 
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

-- Identifying the status of the countries that are left where they are not 'Developing'
SELECT * 
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

-- Using a self join and updating our 'world_life_expectancy' table and setting the blank Status rows to 'Developed' where the Countries already have a status of 'Developed' 
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

-- Identifying which rows in the 'Life Expectancy' column are blank
SELECT Country, 
Year, 
`Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

-- Self joing our world_life_expectancy table twice in order to identify which rows are empty and then get the average life expectancy from the year before and after to populate the empty cells
SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

-- Updating the empty cells from the 'Life expectancy' column with the average life expectancy 
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
WHERE t1.`Life expectancy` = ''
;

-- Taking a look at our data again
SELECT *
FROM world_life_expectancy
#WHERE `Life expectancy` = ''
;