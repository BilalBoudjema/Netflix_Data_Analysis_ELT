-- Data analysis ---


/* 1. For each director, count the number of movies and TV shows they have created in separate columns 
    for directors who have created both movies and TV shows */

SELECT nd.director,
       COUNT(DISTINCT CASE WHEN n.type = 'Movie' THEN n.show_id END) AS no_of_movies,
       COUNT(DISTINCT CASE WHEN n.type = 'TV Show' THEN n.show_id END) AS no_of_tvshow
FROM netflix n
INNER JOIN netflix_directors_table nd ON n.show_id = nd.show_id
GROUP BY nd.director
HAVING COUNT(DISTINCT n.type) > 1;



-- 2. Identify the country with the highest number of comedy movies

SELECT TOP 1 nc.country, 
       COUNT(DISTINCT ng.show_id) AS no_of_movies
FROM netflix_genre_table ng
INNER JOIN netflix_country_table nc ON ng.show_id = nc.show_id
INNER JOIN netflix n ON ng.show_id = nc.show_id
WHERE ng.genre = 'Comedies' AND n.type = 'Movie'
GROUP BY nc.country
ORDER BY no_of_movies DESC;



-- 3. For each year (based on the date added to Netflix), identify which director released the maximum number of movies

WITH cte AS (
    SELECT nd.director, YEAR(date_added) AS date_year, COUNT(n.show_id) AS no_of_movies
    FROM netflix n
    INNER JOIN netflix_directors_table nd ON n.show_id = nd.show_id
    WHERE type = 'Movie'
    GROUP BY nd.director, YEAR(date_added)
),
cte2 AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY date_year ORDER BY no_of_movies DESC, director) AS rn
    FROM cte
)
SELECT * 
FROM cte2  
WHERE rn = 1;



-- 4. Find the average duration of movies in each genre

SELECT ng.genre, 
       AVG(CAST(REPLACE(duration, ' min', '') AS INT)) AS avg_duration
FROM netflix n
INNER JOIN netflix_genre_table ng ON n.show_id = ng.show_id
WHERE type = 'Movie'
GROUP BY ng.genre;



-- 5. Find the list of directors who have created both horror and comedy movies.
-- Display the director names along with the number of comedy and horror movies directed by them

SELECT nd.director,
       COUNT(DISTINCT CASE WHEN ng.genre = 'Comedies' THEN n.show_id END) AS no_of_comedy,
       COUNT(DISTINCT CASE WHEN ng.genre = 'Horror Movies' THEN n.show_id END) AS no_of_horror
FROM netflix n
INNER JOIN netflix_genre_table ng ON n.show_id = ng.show_id
INNER JOIN netflix_directors_table nd ON n.show_id = nd.show_id
WHERE type = 'Movie' AND ng.genre IN ('Comedies', 'Horror Movies')
GROUP BY nd.director
HAVING COUNT(DISTINCT ng.genre) = 2
ORDER BY no_of_comedy DESC, no_of_horror DESC;
