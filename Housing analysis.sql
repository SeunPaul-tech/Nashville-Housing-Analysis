-- CREATING TABLE HOUSING
CREATE TABLE housing (
    UniqueID INTEGER PRIMARY KEY,
    ParcelID VARCHAR(50),
    LandUse VARCHAR(100),
    PropertyAddress TEXT,
    SaleDate TEXT,
    SalePrice TEXT,
    LegalReference VARCHAR(100),
    SoldAsVacant VARCHAR(10),
    OwnerName VARCHAR(255),
    OwnerAddress TEXT,
    Acreage NUMERIC(10,2),
    TaxDistrict VARCHAR(100),
    LandValue NUMERIC(12,2),
    BuildingValue NUMERIC(12,2),
    TotalValue NUMERIC(12,2),
    YearBuilt INTEGER,
    Bedrooms INTEGER,
    FullBath INTEGER,
    HalfBath INTEGER
);

-- DROP TABLE housing 
copy housing FROM 'C:/Users/HP/Downloads/Nashville housingg.csv' WITH (FORMAT CSV, HEADER TRUE);

SELECT saledate, saledate::date
FROM housing;

-- CREATING A COPY OF THE TABLE housing
CREATE TABLE housingg(
	LIKE housing INCLUDING ALL
);

-- drop table housingg
-- ADDING A NEW COLUMN row num to housingg
ALTER TABLE housingg
ADD COLUMN row_num INT;

-- SEARCHING FOR DUPLICATES
WITH duplicates_cte AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY landuse,
				propertyaddress,
				saleprice,
				soldasvacant ORDER BY parcelid) AS row_num
FROM housingg
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

-- copying all housing records into housingg
INSERT INTO housingg
SELECT *,
	ROW_NUMBER() 
	OVER(
	PARTITION BY landuse,
				propertyaddress,
				saleprice,
				soldasvacant ORDER BY parcelid
	) AS row_num
FROM housing

-- checking for duplicate records
SELECT *
FROM housingg
WHERE row_num > 1; 
-- the record shows that we have more than 1000 duplicate records

-- deleting duplicate records
DELETE
FROM housingg
WHERE row_num > 1;

-- DATA CLEANING
-- CONVERTING THE SALEDATE COLUMN FROM TEXT TO DATE
UPDATE housingg
SET saledate = saledate::date

-- CONVERTING THE SALEDATE COLUMN FROM TEXT TO DATE 
ALTER TABLE housingg
ALTER COLUMN saledate TYPE DATE
	USING saledate::DATE;

-- SALEPRICE COLUMN
SELECT saleprice, REPLACE(REPLACE(saleprice, '$',''),',','')::NUMERIC FROM housingg

-- UPDATING THE SALEPRICE COLUMN 
UPDATE housingg
SET saleprice = REPLACE(REPLACE(saleprice, '$',''),',','')::NUMERIC
	
-- CONVERTING THE SALEPRICE COLUMN FROM TEXT TO NUMERIC	
ALTER TABLE housingg
ALTER COLUMN saleprice TYPE NUMERIC
	USING saleprice::NUMERIC;

SELECT *
FROM housingg;

-- standardizing the landuse column
SELECT landuse, INITCAP(landuse)
FROM housingg

UPDATE housingg
SET landuse = INITCAP(landuse)

-- standardizing the propertyaddress column by separating it into address and city columns
SELECT propertyaddress, SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress)-1),
	SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1, LENGTH(propertyaddress))
FROM housingg 

-- creating address column
ALTER TABLE housingg
ADD COLUMN propertyaddresss TEXT;

-- creating city column
ALTER TABLE housingg
ADD COLUMN propertycity TEXT;

-- creating owneraddresss column
ALTER TABLE housingg
ADD COLUMN owneraddresss TEXT;

-- creating ownercity column
ALTER TABLE housingg
ADD COLUMN ownercity TEXT;

-- creating ownerstate column
ALTER TABLE housingg
ADD COLUMN ownerstate TEXT;

---------------------------------------------------------

SELECT owneraddress, 
	SPLIT_PART(owneraddress, ',',1) AS address,
	SPLIT_PART(owneraddress, ',',2) AS city,
	SPLIT_PART(owneraddress, ',',3) AS state
FROM housingg;

-- populating the owneraddresss column
UPDATE housingg
SET owneraddresss = SPLIT_PART(owneraddress, ',',1);

-- populating the ownercity column
UPDATE housingg
SET ownercity = SPLIT_PART(owneraddress, ',',2);

-- populating the ownerstate column
UPDATE housingg
SET ownerstate = SPLIT_PART(owneraddress, ',',3);

-- updating the new address column
UPDATE housingg
SET propertyaddresss = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress)-1);

-- updating the new city column
UPDATE housingg
SET propertycity = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1, LENGTH(propertyaddress));

-- dropping the propertyaddress column
ALTER TABLE housingg
DROP COLUMN propertyaddress;

-- dropping the owneraddress column
ALTER TABLE housingg
DROP COLUMN owneraddress;

SELECT h.parcelid, h.propertyaddresss, g.parcelid, g.propertyaddresss, COALESCE(h.propertyaddresss, g.propertyaddresss)
FROM housingg h
JOIN housingg g
ON h.parcelid = g.parcelid
	AND h.uniqueid <> g.uniqueid
	WHERE h.propertyaddresss IS NULL ;

-- populating the null values in propertyaddress column
UPDATE housingg h
SET propertyaddresss = COALESCE(h.propertyaddresss, g.propertyaddresss)
FROM housingg g
WHERE h.parcelid = g.parcelid
	AND h.uniqueid <> g.uniqueid      
	AND h.propertyaddresss IS NULL 
	AND g.propertyaddresss IS NOT NULL;

-- populating the null values in propertycity column
UPDATE housingg h
SET propertycity = COALESCE(h.propertycity, g.propertycity)
FROM housingg g
WHERE h.parcelid = g.parcelid
	AND h.uniqueid <> g.uniqueid
	AND h.propertycity IS NULL
	AND g.propertycity IS NOT NULL;

-- standardizing the soldasvacant column
SELECT 
	CASE
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
	END
FROM housingg

UPDATE housingg
SET soldasvacant = 	CASE
						WHEN soldasvacant = 'Y' THEN 'Yes'
						WHEN soldasvacant = 'N' THEN 'No'
						ELSE soldasvacant
					END


SELECT AVG(acreage)
FROM housingg; -- the average of acreage column is 0.495, this will be used to impute the null values in the column

-- populating the acreage column with the average of the column
UPDATE housingg
SET acreage = COALESCE(acreage,0.495)

SELECT AVG(landvalue)
FROM housingg; -- 69,158.6

-- populating the landvalue column with the mean value
UPDATE housingg
SET landvalue = COALESCE(landvalue,69158.6);

SELECT AVG(buildingvalue)
FROM housingg; -- 161162.5

-- populating the buildingvalue column with the mean value
UPDATE housingg
SET buildingvalue = COALESCE(buildingvalue,161162.5);

-- dropping the totalvalue column with null values
ALTER TABLE housingg
DROP COLUMN totalvalue;

-- creating a new totalvalue column
ALTER TABLE housingg
ADD COLUMN totalvalue NUMERIC(14,2);

-- populating the new column by adding the values in the landvalue column and buildingvalue column
UPDATE housingg
SET totalvalue = (landvalue + buildingvalue);
	

SELECT *
FROM housingg

-- EXPLORATORY DATA ANALYSIS
-- 1.	What factors have the strongest relationship with property sale prices? 
WITH corr_values AS (
    SELECT 'Total Value' AS factor, CORR(saleprice, totalvalue) AS correlation FROM housing
    UNION ALL
    SELECT 'Building Value', CORR(saleprice, buildingvalue) FROM housing
    UNION ALL
    SELECT 'Land Value', CORR(saleprice, landvalue) FROM housing
    UNION ALL
    SELECT 'Acreage', CORR(saleprice, acreage) FROM housing
    UNION ALL
    SELECT 'Bedrooms', CORR(saleprice, bedrooms) FROM housing
    UNION ALL
    SELECT 'Full Bath', CORR(saleprice, fullbath) FROM housing
    UNION ALL
    SELECT 'Half Bath', CORR(saleprice, halfbath) FROM housing
    UNION ALL
    SELECT 'Year Built', CORR(saleprice, yearbuilt) FROM housing
)

SELECT
    factor,
    ROUND(correlation::numeric, 3) AS correlation,
    CASE
        WHEN ABS(correlation) >= 0.7 THEN 'Strong'
        WHEN ABS(correlation) >= 0.4 THEN 'Moderate'
        WHEN ABS(correlation) >= 0.1 THEN 'Weak'
        ELSE 'Very Weak / None'
    END AS relationship_strength
FROM corr_values
ORDER BY ABS(correlation) DESC;

-- 2.	How has Nashville's housing market changed over time
SELECT 
	saledate::DATE,
	ROUND(AVG(saleprice),1) AS avg_sales_trend
FROM housingg
GROUP BY 1
ORDER BY 2;

-- 3. what is the Total Market Value by Year
SELECT 
	EXTRACT(YEAR FROM saledate) AS year,
	ROUND(SUM(saleprice),1) AS total_sales
FROM housingg
WHERE saledate IS NOT NULL
GROUP BY EXTRACT(YEAR FROM saledate)
ORDER BY total_sales;

-- which property types generate the highest revenue?
SELECT 
	landuse,
	SUM(saleprice) AS revenue	
FROM housingg
GROUP BY landuse
ORDER BY revenue DESC
	LIMIT 10; -- Single family property type generates the most revenue

-- Which locations have the most valuable housing markets?
SELECT 
	propertyaddresss,
	COUNT(*) AS total_numProperties,
	ROUND(AVG(landvalue),1) AS avg_landvalue,
	ROUND(AVG(buildingvalue),1) AS avg_buildingvalue,
	ROUND(AVG(totalvalue),1) AS avg_totalvalue
FROM housingg
GROUP BY propertyaddresss
	HAVING AVG(landvalue) > 69158.6
	AND AVG(totalvalue) > 230321
	AND AVG(buildingvalue) > 161162.5
ORDER BY avg_totalvalue DESC
	LIMIT 20; 
-- 2800  MCGAVOCK PIKE is the location with the most valuable housing market in Nashville with the total value of $13.3m worth of properties

-- 9.	Which tax districts have the highest average property sale prices? 
SELECT taxdistrict,
	ROUND(AVG(saleprice),1) AS avg_saleprice
FROM housingg
WHERE taxdistrict IS NOT NULL
GROUP BY 1
ORDER BY avg_saleprice DESC; 
-- CITY OF BELLE MEADE is the district with the highest property sale on average

-- What percentage of properties were sold as vacant, and how do their sale prices compare with non-vacant properties? 
SELECT 
	soldasvacant,
	COUNT(*) AS total_property_count,
	ROUND(
		COUNT(*) * 100/SUM(COUNT(*)) OVER(),1
	) AS percentage_prop,
	ROUND(
		AVG(saleprice),1
	) AS avg_saleprice,
	ROUND(
	MIN(saleprice),1
	) AS min_saleprice,
	ROUND(
	MAX(saleprice),1
	) AS max_saleprice,
	ROUND(
	SUM(saleprice),1
	) AS totalsale
FROM housingg
GROUP BY soldasvacant
ORDER BY percentage_prop; -- 7.8% of the properties were sold as vacant while 92.2% were sold as non-vacant. In addition, there's little gap between the average saleprice of the
-- vacant properties compared to the non-vacant properties. Avg price of $2.9m of vacant properties to $3.1m of non-vcant props.

-- What is the percentage of properties by the number of bedrooms?
SELECT 
	bedrooms,
	COUNT(*) AS property_count,
	ROUND(
		COUNT(*) * 100/ SUM(COUNT(*)) OVER(),1
	) AS percent_of_props
FROM housingg
WHERE bedrooms IS NOT NULL
GROUP BY bedrooms
ORDER BY percent_of_props DESC; -- properties with three bedrooms account for highest percentage with 53.3% with over 12k properties, followed by 2 bedrooms with 21.1%, 4 bedrooms
-- with 20.1%, etc.

-- Do larger properties (Acreage) generally sell for higher prices? 
SELECT CORR(acreage, saleprice) AS acreage_corr
FROM housingg; -- the result of 0.07 shows a very weak positive relationship signifying no meaninggul linear relationship

-- What is the relationship between property age (Year Built) and sale price
ALTER TABLE housingg
ALTER COLUMN yearbuilt TYPE DATE
	USING TO_DATE(yearbuilt::text, 'YYYY');

WITH year_sec AS (
	SELECT  
		EXTRACT(year FROM yearbuilt) AS year,
		ROUND(AVG(saleprice),0) AS avg_saleprice
	FROM housingg
	GROUP BY year	
)
SELECT
	CASE
		WHEN year < 1900 THEN 'Before 1900'
		WHEN year BETWEEN 1900 AND 1910 THEN '1900-1910'
		WHEN year BETWEEN 1911 AND 1920 THEN '1911-1920'
		WHEN year BETWEEN 1921 AND 1930 THEN '1921-1930'
		WHEN year BETWEEN 1931 AND 1940 THEN '1931-1940'
		WHEN year BETWEEN 1941 AND 1950 THEN '1941-1950'
		WHEN year BETWEEN 1951 AND 1960 THEN '1951-1960'
		WHEN year BETWEEN 1961 AND 1970 THEN '1961-1970'
		WHEN year BETWEEN 1971 AND 1980 THEN '1971-1980'
		WHEN year BETWEEN 1981 AND 1990 THEN '1981-1990'
		WHEN year BETWEEN 1991 AND 2000 THEN '1991-2000'
		WHEN year BETWEEN 2001 AND 2010 THEN '2001-2010'
		WHEN year BETWEEN 2011 AND 2020 THEN '2011-2020'
	ELSE '2021 and above'
	END AS year_group,
	avg_saleprice
FROM year_sec
WHERE year IS NOT NULL
-- GROUP BY avg_saleprice
ORDER BY avg_saleprice DESC;
	
SELECT *
FROM housingg
WHERE yearbuilt is not null