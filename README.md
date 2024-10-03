# Netflix Movies and TV Shows Data Analysis Using SQL

![Netflix Logo](https://upload.wikimedia.org/wikipedia/commons/0/08/Netflix_2015_logo.svg)

## Overview
This project provides an in-depth analysis of the Netflix dataset using SQL. The goal is to derive valuable insights about the distribution, ratings, and trends of Movies and TV Shows on Netflix. The dataset includes various features such as the title, director, country, release year, duration, and rating.

## Objectives

1. **Analyze** the distribution of Movies vs TV Shows.
2. **Identify** the most common ratings for Movies and TV Shows.
3. **List** content based on specific release years.
4. **Find** the top countries with the most content.
5. **Identify** the longest movie and content added recently.
6. **Categorize** content based on keywords like 'kill' and 'violence'.

## Dataset

The dataset used for this project can be found on [Kaggle - Netflix Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download). It contains data on Movies and TV Shows available on Netflix, including details such as title, country, release year, rating, and more.

### Schema

| Column Name    | Description                                                                 |
|----------------|-----------------------------------------------------------------------------|
| `show_id`      | Unique ID for every Movie/TV Show                                           |
| `type`         | The type of content - Movie or TV Show                                      |
| `title`        | Title of the Movie/TV Show                                                  |
| `director`     | Director of the Movie/TV Show                                               |
| `cast`         | Main cast members of the Movie/TV Show                                      |
| `country`      | Country where the Movie/TV Show was produced                                |
| `date_added`   | Date when the Movie/TV Show was added to Netflix                            |
| `release_year` | Year when the Movie/TV Show was originally released                         |
| `rating`       | Rating of the Movie/TV Show                                                 |
| `duration`     | Duration of the Movie in minutes or number of seasons for TV Shows          |
| `listed_in`    | Genre(s) in which the Movie/TV Show is listed                               |
| `description`  | Brief description of the Movie/TV Show                                      |

---


## SQL Queries and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
    type, 
    COUNT(*) AS Total_Number 
FROM netflix
GROUP BY 1;
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows

```sql
WITH rankedrating AS (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS count, 
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rankings
    FROM netflix
    GROUP BY 1, 2
)
SELECT 
    type, 
    rating 
FROM rankedrating 
WHERE rankings = 1;
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)

```sql
SELECT * 
FROM netflix
WHERE release_year = 2020;
```

**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix

```sql
SELECT 
    country, 
    COUNT(show_id) AS Total_Content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie

```sql
SELECT * 
FROM netflix
WHERE type = 'Movie'
AND duration = (SELECT MAX(duration) FROM netflix WHERE type = 'Movie');
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years

```sql
SELECT *
FROM netflix
WHERE STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

```sql
SELECT * 
FROM netflix 
WHERE director LIKE '%Rajiv Chilaka%';
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
SELECT * 
FROM netflix 
WHERE type = 'TV Show' 
AND duration LIKE '%Seasons' 
AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 5;
```

**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre

```sql
SELECT listed_in, COUNT(*) 
FROM netflix
GROUP BY listed_in;
```

**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

```sql
SELECT 
    release_year, 
    CAST(COUNT(show_id) AS UNSIGNED) / CAST((SELECT COUNT(*) FROM netflix WHERE country LIKE '%India%') AS UNSIGNED) * 100 AS avg_content 
FROM netflix
WHERE country LIKE '%India%'
GROUP BY release_year
ORDER BY 2 DESC
LIMIT 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries

```sql
SELECT * 
FROM netflix 
WHERE type = 'Movie' 
AND listed_in LIKE '%Documentaries%';
```

**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director

```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
SELECT * 
FROM netflix 
WHERE casts LIKE '%Salman Khan%' 
AND STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 10 YEAR;
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
SELECT casts, COUNT(show_id) 
FROM netflix
WHERE country LIKE '%India%'
GROUP BY casts
ORDER BY COUNT(show_id) DESC
LIMIT 10;
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
WITH content_type AS (
    SELECT *,
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'BadContent'
            ELSE 'GoodContent'
        END AS category
    FROM netflix
)
SELECT category, type, COUNT(*) 
FROM content_type
GROUP BY category, type;
```

**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

