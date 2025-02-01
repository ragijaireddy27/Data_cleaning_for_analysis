-- find percentage of the each population
alter table country modify percentage DECIMAL(10,4);
set @a=(select sum(population) from country);
update country
set percentage = (population / @a) * 100;

-- Update NULL GDP with a default value (e.g., 0) in the 'country' table
select name, population from country where population is null;
select name, gdp from country where gdp is null;


-- check for NULL values or empty fields in key columns.

use world;
select *from city;
select count(*) as missing from city  where name and population is null;

select *from country;
select *from country where indepyear is null or gnpold or code or name or continent 
or region or SurfaceArea or Population or LifeExpectancy or gnp or localname 
or governmentform or headofstate or capital or code2 is null;

update country set capital=10 where capital is null;
update country set  headofstate='N/A' where  headofstate='';
update country set  LocalName='N/A' where LocalName like '_';
update country set indepyear=2000 where indepyear is null ;
update country set gnpold=5000.00 
where gnpold is null;
update country set LifeExpectancy=60.0 where LifeExpectancy is null ;
-- city table
select *from city; 
select *from city where district ='' or id='' or name='' or population='' or countrycode  ;

-- to check for duplicate entries in the payment table

select code from country group by code having count(*)>1;


select *from country;



--  to find outliers in film length
select *from country where population=0;
update country set population=10000 where population=0;
-- to check if numeric fields are stored as text
SELECT COUNT(*)
FROM country
WHERE LENGTH(surfacearea) > 500;  -- Assuming surfacearea is a numeric column but stored as text
 -- to check for inconsistent country names in customer table

select distinct name from country;

-- Check for duplicate countries by name:


select name, count(*) from country group by name having count(*) > 1;


-- check for duplicate cities by name in the same country:


select name, country_id, count(*) from city group by name, country_id having count(*) > 1;

-- remove duplicate cities, keeping the first entry:
delete c1 from city c1 join city c2 on c1.name = c2.name and c1.country_id = c2.country_id where c1.id > c2.id;

-- Check for non-numeric population values
select name, population from country where population like '%^0-9%';
-- Remove non-numeric characters from population values
update country set population = replace(population, ',', '') where population like '%[^0-9]%';
-- Check for outlier population values
select name, population from country where population > 1000000000 or population < 1000;
-- Update population value for a specific country
update country set population = 1000000 where name = 'some country' and population > 1000000000;
-- Check for redundant languages for the same country
select country_id, language, count(*) from countrylanguage group by country_id, language having count(*) > 1;
-- Delete cities with invalid country_id
delete from city where country_id not in (select country_id from country);

-- Remove duplicate cities, keeping the first entry
delete c1 from city c1 join city c2 on c1.name = c2.name and
 c1.country_id = c2.country_id where c1.id > c2.id;