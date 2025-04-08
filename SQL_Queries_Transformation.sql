-- handling forign characters 

CREATE DATABASE Netflix_DB COLLATE Latin1_General_100_CI_AI_SC_UTF8;

use Netflix_DB;
Go

SELECT DB_NAME() AS CurrentDatabase



---------------------------------------

drop TABLE netflix_table12

CREATE TABLE netflix_table12(
    [show_id] [VARCHAR](10) primary key  NOT NULL,
    [type] [NVARCHAR](255) NULL,
    [title] [NVARCHAR](400) NULL,
    [director] [NVARCHAR](255) NULL,
    [cast] [NVARCHAR](4000) NULL,
    [country] [NVARCHAR](255) NULL,
    [date_added] [NVARCHAR](255) NULL,
    [release_year] [int] NULL,
    [rating] [NVARCHAR](255) NULL,
    [duration] [NVARCHAR](255) NULL,
    [listed_in] [NVARCHAR](255) NULL,
    [description] [NVARCHAR](255) NULL
);



-- remove duplicates show id 
select show_id, count(*) as number_of_repition
from netflix_table12
group by show_id
having count(*) >1

-- remove duplicates title

-- remove duplicates 

select * from netflix_table12
where concat (upper(title),type) in (

	select concat (upper(title),type)
	from netflix_table12
	group by concat (upper(title),type)
	having count(*)> 1
)
order by title

-- handling hr duplicated records ( keeping only  one for each show_id and title ) 

with cte as (
select *
, ROW_NUMBER() over ( partition by title , type order by show_id ) as rn
from netflix_table12 ) 

select * from cte 
where rn = 1 




--------------------------------
-- creating new table of directors 

select  show_id ,trim(value) as director
into netflix_directors_table
from netflix_table12
cross apply string_split(director,',')


-- creating new table of country  

select  show_id ,trim(value) as country
into netflix_country_table
from netflix_table12
cross apply string_split(country,',')


-- creating new table of cast

select  show_id ,trim(value) as cast
into netflix_cast_table
from netflix_table12
cross apply string_split(cast,',')




-- creating new table of listed_in

select  show id ,trim(value) as genre
into netflix_genre_table
from netflix_table12
cross apply string_split(listed_in,',')

-- filing missing country values 
insert into netflix_country_table
select  show_id,m.country 
from netflix_table12 nr
inner join (
select director,country
from  netflix_country_table nc
inner join netflix_directors_table nd on nc.show_id=nd.show_id
group by director,country
) m on nr.director=m.director
where nr.country is null



-- handling hr duplicated records ( keeping only  one for each show_id and title ) 

with cte as (
select *
, ROW_NUMBER() over ( partition by title , type order by show_id ) as rn
from netflix_table12 ) 

select show_id, type, title , cast(date_added as date ) as date_added , release_year , rating , duration, description  
from cte 
where rn = 1 







-- handling duration missing vluer 

-- handling hr duplicated records ( keeping only  one for each show_id and title ) 

with cte as (
select *
, ROW_NUMBER() over ( partition by title , type order by show_id ) as rn
from netflix_table12 ) 

select show_id, type, title , TRY_CAST( date_added as date ) as date_added , release_year , rating , case when duration is null  then rating  else duration end  as duration, description  
from cte 
where rn = 1 



-- finale clean table 

with cte as (
select *
, ROW_NUMBER() over ( partition by title , type order by show_id ) as rn
from netflix_table12 ) 

select show_id, type, title , TRY_CAST( date_added as date ) as date_added , release_year , rating , case when duration is null  then rating  else duration end  as duration, description  
into netflix
from cte 





