CREATE TABLE details(
show_id VARCHAR (5),
type_ VARCHAR(10),
title VARCHAR(110),
director VARCHAR (210),
casts VARCHAR (1000),	
country	VARCHAR(125),
date_added VARCHAR (20),
release_year INT,
rating VARCHAR(10),
duration VARCHAR (10),
listed_in VARCHAR (80),
description VARCHAR (300));

SELECT * FROM details;

-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems

-- 1. Count the number of Movies vs TV Shows

SELECT type_, COUNT(*) as total_content
FROM details
GROUP BY 1;

-- 2. Find the most common rating for movies and TV shows

WITH RatingCounts AS (
    SELECT 
        type_,
        rating,
        COUNT(*) AS rating_count
    FROM details
    GROUP BY type_, rating
),
RankedRatings AS (
    SELECT 
        type_,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type_ ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type_,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

-- 3. List 10 movies released in a specific year (e.g., 2020)

SELECT * 
FROM details
WHERE release_year = 2020
LIMIT 10



-- 4. Find the top 5 countries with the most content on Netflix

SELECT * 
FROM
(
	SELECT 
		-- country,
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM details
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5

-- 5. Identify the longest movie

SELECT * FROM details
WHERE type_ ='Movie'
AND duration = (SELECT MAX(duration) FROM details);




-- 6. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT * FROM details
WHERE director LIKE '%Rajiv Chilaka%';

-- 7. List all TV shows with more than 5 seasons


SELECT *
FROM details
WHERE 
	type_ = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5

-- 8. Count the number of content items in each genre

SELECT COUNT(show_id) AS items_count, UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre  FROM details
GROUP BY 2
ORDER BY 1 DESC;

-- 9. List all movies that are documentaries

SELECT * FROM details
WHERE listed_in ILIKE '%Documentaries'


--10. Find all content without a director

SELECT * FROM details
WHERE director IS NULL



-- 11. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM details
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 12. Find the top 10 actors who have appeared in the highest number of movies produced in India.



SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM details
WHERE country ILIKE '%India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

/*
Question 13.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	type_,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM details
) AS categorized_content
GROUP BY 1,2
ORDER BY 3 DESC























