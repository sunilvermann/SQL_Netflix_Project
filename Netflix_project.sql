--Netflix_Project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
	show_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(150),
	description VARCHAR(300)
);
SELECT * FROM netflix;


-- Q1. Count the total number of records.
SELECT COUNT(*) AS total_records FROM netflix;

-- Q2. Find the different type of contents in netflix.
SELECT DISTINCT type FROM netflix;

-- Q3. Count the number of Movies and TV shows.
SELECT type, COUNT(*) AS total_count 
FROM netflix
GROUP BY type;

-- Q4. Find the most common Rating for movies and TV shows.
SELECT type, rating FROM
(SELECT type, rating, COUNT(*), 
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1, 2) as T1
WHERE ranking = 1;

-- Q5. List all movies released in a specific year(e.g 2020).
SELECT type, release_year
FROM netflix
WHERE type='Movie' AND release_year = 2020;

-- Q6. Find the top countries with the most content on netflix.
SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1 ORDER BY 2 DESC LIMIT 5;


SELECT * FROM netflix;
--Q7. Find the longest movie.
SELECT * FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM netflix);

-- Q8. Find the content added in the last 5 years.
SELECT  *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

-- Q9. Find the all movie/TV shows by director 'Rajiv Chilaka'.(ILIKE IS USED FOR SMALL AND UPPERCASE LETTER)
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- Q10. List all TV shows with more then 5 seasons.
SELECT * 
FROM netflix
WHERE type='TV Show' AND SPLIT_PART(duration, ' ', 1)::numeric > 5;

-- Q11. Count the number of content items in each genre.
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;

-- Q12. Find each year and the average number of content release by India on netflix.
--  return top 5 years with highest average content release.
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
COUNT(*) AS yeary_content,
COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) AS average_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;

-- Q13. List all movies that are documentries.
SELECT * 
FROM netflix
WHERE type='Movie' AND listed_in ILIKE '%Documentaries%';

-- Q14. Find all content without a director.
SELECT * 
FROM netflix
WHERE director IS NULL;
