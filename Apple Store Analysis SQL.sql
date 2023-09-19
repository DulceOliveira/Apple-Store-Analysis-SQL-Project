-- **Data Analysis of Apple Store**

CREATE TABLE appleStore_description_combined 
AS
SELECT * FROM appleStore_description1
UNION ALL 
SELECT * FROM appleStore_description2
UNION ALL 
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4;

-- **Exploratory Data Analysis**

-- Checking the number of unique apps in both tablesAAppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
from AppleStore;

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
from appleStore_description_combined;

-- Checking for any missing vaalues in some of the key fields

SELECT COUNT(*) as MissingValues
FROM AppleStore
where track_name is null OR user_rating is null OR prime_genre is NULL;


SELECT COUNT(*) as MissingValues
FROM appleStore_description_combined
where app_desc is null;


SELECT COUNT(*) as MissingValues
FROM AppleStore
where track_name is null OR user_rating is null OR prime_genre is NULL;


-- Finding out the number of apps per genreAppleStore
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC;

-- Get an overview of the apps' raqtingsAppleStore

SELECT min(user_rating) AS MinRating,
       max(user_rating) AS Maxrating,
       avg(user_rating) AS AvgRating
FROM AppleStore;  

-- **Data Analysis**

-- Detwermine whether paid apps have higher ratings than free appsAppleStore

SELECT CASE
           WHEN price > 0 THEN 'Paid'
           ELSE 'Free'
       END AS App_Type,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type;

-- Checking if apps with more supported languages have higher ratings

SELECT CASE
            WHEN lang_num < 10 THEN '<10 languages'
            when lang_num BETWEEN 10 AND 30 then '10-30 languages'
            else '>30 languages'
      END as language_bucket,
      avg(user_rating) AS avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER by Avg_Rating DESC;

-- Checking genres with low ratingsAppleStore

select prime_genre,
       avg(user_rating) as Avg_Rating
FROM AppleStore
group by prime_genre
order by Avg_Rating aSC
limit 10;

-- Checking if there is correlation between the lenght of the app description and the user rating 

SELECT CASE
            WHEN length(b.app_desc) < 500 THEN 'Short'
            WHEN length(b.app_desc) BETWEEN 500  and 1000 THEN 'Medium'
            ELSE 'Long'
      end as description_length_bucket,
      avg(a.user_rating) as average_rating
             

from 
     AppleStore as A
JOIN
     appleStore_description_combined as b
on 
     a.id = b.id

group by description_length_bucket
order by average_rating desc;


-- Checking the top rated apps for each genreAppleStore = With this query, retrieves all the apps with the highest 

select 
       prime_genre,
       track_name,
       user_rating
from( 
     SELECT
     prime_genre,
     track_name,
     user_rating,
     RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot desc) AS rank
     FROM
     AppleStore
  )   AS a
  
  WHERE
  a.rank = 1;