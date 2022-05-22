
--------------------------------------------------
-- Create a new database for task 3 ' cw_task3' --
--------------------------------------------------
create database cw_task3

use cw_task3
-------------------------------------------------------------
-- Combining all the tables together from Manchester crime --
-------------------------------------------------------------

Select * 
INTO Greater_Manchester_Crime From
(Select *
From [dbo].['2017-01-greater-manchester-stre$']
UNION ALL
Select * 
From [dbo].['2017-02-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-03-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-04-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-05-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-06-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-07-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-08-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-09-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-10-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-11-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2017-12-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-01-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-02-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-03-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-04-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-05-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-06-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-07-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-08-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-09-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-10-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-11-greater-manchester-stre$']
UNION ALL
Select *
From [dbo].['2018-12-greater-manchester-stre$']) AS Greater_Manchester_Crime;
------------------------------------------------------------------------------------------------------------------
-- Creating primary key to prevent the duplicate in our dataset --
-------------------------------------------------------------------------------------------------------------------
ALTER TABLE [cw_task3].[dbo].[Greater_Manchester_Crime]
ADD Manchester_ID INT IDENTITY;
ALTER TABLE [cw_task3].[dbo].[Greater_Manchester_Crime]
ADD CONSTRAINT PK_Manchester_ID PRIMARY KEY NONCLUSTERED (Manchester_ID);
------------------------------------------------------------------------------------------------
-- Creating a Geolocation column by using Geography datatype --
------------------------------------------------------------------------------------------------
ALTER TABLE [cw_task3].[dbo].[Greater_Manchester_Crime]
ADD [GeoLocation] GEOGRAPHY
-----------------------------------------------------------
-- Creating Geography Points to be used in QGIS database -- 
-----------------------------------------------------------
UPDATE [cw_task3].[dbo].[Greater_Manchester_Crime]
SET [GeoLocation] = GEOGRAPHY::Point([Longitude],[Latitude], 4326)
WHERE [Longitude] IS NOT NULL
AND [Latitude] IS NOT NULL

------------------------------------------------------------------------------------------------------------------------
-- Now we will add the population column into new table called Lsao_Pop --
------------------------------------------------------------------------------------------------------------------------
Select a.LSOA_Name, b.Population,count(a.LSOA_Code) as Crimes
INTO Lsoa_Pop
From Greater_Manchester_Crime a
INNER JOIN population_table b
ON b.LSOA_Codes = a.LSOA_Code
group by a.LSOA_Name, b.Population 


select * from Lsoa_Pop


----------------------------------------------------------------------------------------------------------------
-- Now we will create and add the population column from population table into Greater Manchester Crime table --
----------------------------------------------------------------------------------------------------------------
Create view Manchester_and_population as

select a.*,b.population from Greater_Manchester_Crime a
inner join population_table b on b.lsoa_name=a.[LSOA_name]


-----------------------------------------------------------------------------------------------
-- Now we will run the Greater Manchester Crime dataset to view all the changes we have done --
-----------------------------------------------------------------------------------------------
select * from Manchester_and_population



----------------------------------------------------------------------------------------------
-- Before we start building our reports, we will run a query to have an overview and see how many crimes we have in each type --
----------------------------------------------------------------------------------------------


select Crime_Type, count(crime_type) as Crime_Numbers from Greater_Manchester_Crime group by [Crime_type] order by count(crime_type) desc

--------------------------
-- Create view - one - --
--------------------------
Create view drugs_bicycle_theft as

select lsoa_name,crime_type,geolocation,longitude,latitude,population
from Manchester_and_population
where crime_type = 'Drugs' or crime_type = 'Bicycle theft'

select * from drugs_bicycle_theft
--------------------------
-- Create View - Two - --
--------------------------
create view Burglary_Shoplifting as
select lsoa_name,crime_type,geolocation,longitude,latitude,population from Manchester_and_population
where crime_type = 'Burglary' or crime_type = 'Shoplifting'

select * from Burglary_Shoplifting

---------------------------
-- Create View - Three - --
---------------------------
create view Robbery  as
select lsoa_name,crime_type,geolocation,longitude,latitude,population 
from Manchester_and_population
where crime_type = 'Robbery' 

select * from Robbery

---------------------------
-- Create View - Four - ---
---------------------------
create view Vehicle_Crime  as
select lsoa_name,crime_type,geolocation,longitude,latitude,population from Manchester_and_population
where crime_type = 'Vehicle crime' 

select * from Vehicle_Crime

----------------------------
-- Create View - Five -- ---
----------------------------
create view Anti_social_behaviour  as
select lsoa_name,crime_type,geolocation,longitude,latitude,population 
from Manchester_and_population
where crime_type = 'Anti-social behaviour' and Lsoa_name like 'salford%'

select * from Anti_social_behaviour 

-----------------------------------------------------------------------------------------------------------
