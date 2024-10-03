create database SqlProject;
select * from netflix;

-- 1. Count the number of Movies vs TV Shows

select 
	type, 
    count(*) as Total_Number 
from netflix
group by 1;

-- 2. Find the most common rating for movies and TV shows

with rankedrating as(
select 
	type, 
    rating, 
    count(*),
    rank() over(partition by type order by count(*) desc) as rankings
from netflix
group by 1,2
order by 3 desc)

select 
	type, 
	rating 
from rankedrating 
where rankings = 1;

-- 3. List all movies released in a specific year (e.g., 2020)

select * from netflix
where release_year = 2020;

-- 4. Find the top 5 countries with the most content on Netflix

select 
	country,
    count(show_id) as Total_Content
from netflix
group by 1
order by 2 desc
limit 5;

-- 5. Identify the longest movie

select * from netflix
where type = 'Movie'
and duration = (select max(duration) from netflix where type = 'Movie');

-- 6. Find content added in the last 5 years

SELECT *
FROM netflix
WHERE
    STR_TO_DATE(date_added, '%M %d, %Y') >= CURDATE() - INTERVAL 5 YEAR;


-- 7. Find all the movies/TV shows by director 'Toshiya Shinohara'

select * from netflix 
where director like '%Toshiya Shinohara%';

-- 8. List all TV shows with more than 5 seasons

select * from netflix 
where type = 'TV show' and duration like '%Seasons'
and cast(substring_index(duration,' ',1) as unsigned) > 5;

-- 9. Count the number of content items in each genre

select listed_in,count(*) from netflix
group by listed_in;

-- 10.Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!

select 
	release_year, 
    cast(count(show_id) as unsigned)/cast((select count(*) from netflix where country like '%India%') as unsigned) * 100 as avg_content 
from netflix
where country like '%India%'
group by release_year
order by 2 desc
limit 5;

-- select str_to_date(date_added, '%M %d,%Y'), extract(year from str_to_date(date_added, '%M %d,%Y')) from netflix;

-- 11. List all movies that are documentaries

select * from netflix 
where type ='Movie' and
listed_in like '%Documentaries%';

-- 12. Find all content without a director

select * from netflix
where director is null;

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix 
where cast like '%Salman Khan%'
and str_to_date(date_added, '%M %d, %Y') >= curdate() - interval 10 year;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select cast, count(show_id) from netflix
group by cast;

-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.

with content_type as (
select *,
	case when description like '%kill%' or description like '%violence%' then 'BadContent'
		else 'GoodContent'
	end category
from netflix)

select category, type , count(*) from content_type
group by category, type;

