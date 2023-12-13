CREATE table applestore_description AS

SELECT * from appleStore_description1

union ALL

SELECT * from appleStore_description2

union ALL

SELECT * from appleStore_description3

union ALL

SELECT * from appleStore_description4

**Exploratory Data Analysis**

--Check the number of unique applications in both tables

select 
	COUNT(DISTINCT(id)) AS UniqueAppIDs
from AppleStore

select 
	count(DISTINCT(id)) as UniqueAppIDs
from applestore_description

--Both of the results are 7197. Which implies that there is no missing data. Hence no discrepancy.

--Check for any missing values in any key fields of the table

SELECT 
	COUNT(*) as MissingValues
from AppleStore
where 
	track_name IS NULL OR
    user_rating is NULL OR
    prime_genre is NULL

SELECT 
	COUNT(*) as MissingValues
from applestore_description
where 
	app_desc IS NULL

--No missing values

--Find out the number of apps per genre

SELECT 
	prime_genre,
    count(*) AS NumApps
from AppleStore
group by prime_genre
order by NumApps desc

--We can see the genre of Games is leading with a huge margin. Followed by Entertainment and EducationAppleStore

--Getting an overview of the app's ratings

SELECT 
	min(user_rating) as MinRating,
    max(user_rating) as MaxRating,
    avg(user_rating) as AvgRating
from AppleStore


**DATA ANALYSIS**

--Determine whether paid apps hae higher rating than free apps

SELECT 
	CASE
		when price>0 then 'Paid'
		else 'Free'
		end as App_Type,
	avg(user_rating) as Avg_Rating
from AppleStore
GROUP by App_Type
ORDER by Avg_Rating desc

--Rating of Paid apps is slightly higher than free apps
        
--Check if apps that support more languages have higher rating

SELECT 
	CASE
		when lang_num<10 then '<10 Languuages'
		when lang_num BETWEEN 10 and 30 then '10-30 Languuages'
		else '>30 Languages'
		end as language_bucket,
	avg(user_rating) as Avg_Rating
from AppleStore
group by language_bucket
ORDER by Avg_Rating desc

--The middle bucket (10-30 languages) has highest ratings so we dont necessarily need to focus on providing many languages. Instead we can focus on other aspects.

--Check the genres with low ratings

SELECT
	prime_genre,
    avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating
limit 10

--Catalogs, Finance and Book are the genres in which users have given the lowest ratings. So, it would be wise not to explore these genres

--Check to see if there is a correlation between the app description and the user ratings

SELECT
	case
    	when length(D.app_desc)<500 then 'Short'
        when length(D.app_desc) BETWEEN 500 and 1000 then 'Medium'
        else 'Long'
        end as Description_length,
	avg(user_rating) as Avg_Rating
FROM
	AppleStore as A
    join 
    applestore_description as D
    on  A.id = D.id
group by Description_length
order by Avg_Rating desc

--Longer descriptions have higher ratings

--Check the top-rated apps for each genre

SELECT
	prime_genre,
    track_name,
    user_rating
FROM
	(
      SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre ORDER by user_rating desc, rating_count_tot DESC) as Rank
      from 
      AppleStore
      ) as a
WHERE
a.rank = 1

--This will help in taking inspiration from the top apps of each category


**RECOMMENDATIONS**

1. Paid apps generally achieves higher ratings than their free counterparts. Users paying for an app may have higher engagement and percieve more value.
2. Apps supporting 10-30 languages have better rating. So focus should be more on providing the right languages.
3. Finance and Book apps have lower ratings suggesting that user needs are not being met. This may represent opportunity for market penetration by adressing user needs.
4. App Descriptions lengths have a positive correlation with user ratings. Users appreciate having a clear understandings of the apps capabilities and features. Hence Descriptions have to be detailed and well crafted.
5. A new app should aim for an average rating above 3.5
6. Games and Entertainment genres have a very high volume of apps suggesting saturation. Hence entering these genres may be challenging due to high competition. However, it also suggests high user demand in these genres.


