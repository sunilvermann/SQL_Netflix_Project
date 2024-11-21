# Netflix Movies and TV Shows Data Analysis Project Using SQL

## Project Overview

**Project Title**: Netflix Movie and TV Shows Analysis
**Database**: `Netflix_project`

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. 

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
```sql
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
```
## Business Problems and Solutions

### Q1. Count the total number of records.
```sql
SELECT COUNT(*) AS total_records FROM netflix;
```

### Q2. Find the different type of contents in netflix.
```sql
SELECT DISTINCT type FROM netflix;
```

### Q3. Count the number of Movies and TV shows.
```sql
SELECT type, COUNT(*) AS total_count 
FROM netflix
GROUP BY type;
```

### Q4. Find the most common Rating for movies and TV shows.
```sql
SELECT type, rating FROM
(SELECT type, rating, COUNT(*), 
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1, 2) as T1
WHERE ranking = 1;
```

### Q5. List all movies released in a specific year(e.g 2020).
```sql
SELECT type, release_year
FROM netflix
WHERE type='Movie' AND release_year = 2020;
```
### Q6. Find the top countries with the most content on netflix.
```sql
SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1 ORDER BY 2 DESC LIMIT 5;
```

### Q7. Find the longest movie.
```sql
SELECT * FROM netflix
WHERE type = 'Movie' AND duration = (SELECT MAX(duration) FROM netflix);
```

### Q8. Find the content added in the last 5 years.
```sql
SELECT  *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

### Q9. Find the all movie/TV shows by director 'Rajiv Chilaka'.(ILIKE IS USED FOR SMALL AND UPPERCASE LETTER)
```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```

### Q10. List all TV shows with more then 5 seasons.
```sql
SELECT * 
FROM netflix
WHERE type='TV Show' AND SPLIT_PART(duration, ' ', 1)::numeric > 5;
```

### Q11. Count the number of content items in each genre.
```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;
```

### Q12. Find each year and the average number of content release by India on netflix. Return top 5 years with highest average content release.
```sql
SELECT EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
COUNT(*) AS yeary_content,
COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100, 2) AS average_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1;
```

### Q13. List all movies that are documentries.
```sql
SELECT * 
FROM netflix
WHERE type='Movie' AND listed_in ILIKE '%Documentaries%';
```


### Q14. Find all content without a director.
```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

### Q15. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years.
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### Q16. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India.
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC LIMIT 10;
```

### Q17. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.
```sql
SELECT category, COUNT(*) AS content_count
FROM 
(SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
  FROM netflix) AS categorized_content
GROUP BY category;
```

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

