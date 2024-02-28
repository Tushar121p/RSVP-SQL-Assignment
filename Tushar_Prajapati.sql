USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
select count(*) as total_rows from director_mapping;
select count(*) as total_rows from genre;
select count(*) as total_rows from movie;
select count(*) as total_rows from names;
select count(*) as total_rows from ratings;
select count(*) as total_rows from role_mapping;








-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select
count(*) - count(id) as id_null_count,
count(*) - count(title) as title_null_count,
count(*) - count(year) as year_null_count,
count(*) - count(date_published) as date_published_null_count,
count(*) - count(duration) as duration_null_count,
count(*) - count(country) as country_null_count,
count(*) - count(worlwide_gross_income) as worlwide_gross_income_null_count,
count(*) - count(languages) as languages_null_count,
count(*) - count(production_company) as production_company_null_count
from movie;







-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year, count(*) as number_of_movies
from movie
group by year
order by year;
-- Number of movies for each month 
select extract(month from date_published) as months, count(*) as number_of_movies
from movie
group by months
order by months;







/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select year,count(distinct id) as movies_produced_in_the_USA_or_India
from movie
where country like '%USA%' or country like '%India%'
group by year
having year = 2019
order by year;








/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre from genre;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
select g.genre,count(m.id) as Number_of_movies
from genre as g
inner join movie as m
on g.movie_id = m.id
group by g.genre
order by Number_of_movies desc
limit 1; 







/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


select count(*) 
from (select movie_id, count( genre) as genre_count
from genre
group by movie_id
having genre_count =1) as movies_with_one_genre;





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre ,round(avg(m.duration),2) as avg_duration
from genre as g 
inner join movie as m
on g.movie_id = m.id
group by genre
order by avg_duration desc;








/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
with genre_summary as (
select genre,
count(movie_id) as movie_count,
rank() over (order by count(movie_id) desc) as genre_rank
from genre
group by genre)
select genre, movie_count, genre_rank
from genre_summary
where genre = 'thriller';









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
select min(avg_rating) as min_avg_rating, 
max(avg_rating) as max_avg_rating,
min(total_votes)as min_total_votes ,
max(total_votes) as max_total_votes,
min(median_rating) as min_median_rating,
max(median_rating) as max_median_rating
from ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
select m.title , r.avg_rating, rank() over(order by r.avg_rating desc) as movie_rank
from movie as m
inner join ratings as r
on m.id = r.movie_id
order by r.avg_rating desc
limit 10;








/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select median_rating, count(movie_id) as movie_count
from ratings
group by median_rating
order by movie_count desc;




/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
with prod_company_rank_summary
as (select distinct production_company, count(id) as movie_count,RANK() OVER (ORDER BY COUNT(id) DESC) AS prod_company_rank
from movie
where id in (select distinct movie_id from ratings where avg_rating > 8 group by movie_id)
group by production_company
having production_company is not null
order by movie_count desc)
select * 
from prod_company_rank_summary 
where prod_company_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

select g.genre, count(m.id) as movie_count
from genre as g
inner join movie as m on g.movie_id = m.id
inner join ratings as r on m.id = r.movie_id
where m.country like '%USA%' 
and year = 2017
and extract(month from m.date_published) = 3
and r.total_votes > 1000
group by g.genre
order by movie_count desc;







-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


select m.title, r.avg_rating, g.genre
from genre as g
inner join movie as m on g.movie_id = m.id
inner join ratings as r on m.id = r.movie_id
where m.title like 'The%' 
and r.avg_rating > 8
ORDER BY g.genre, r.avg_rating DESC;








-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select count(*) as median_rating_count
from ratings
WHERE median_rating = 8
and movie_id in(select id from movie 
where date_published >= '2018-04-01'
and date_published < '2019-04-01' );








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
select m.country,sum(r.total_votes) as total_votes
from ratings as r
inner join movie as m
on r.movie_id =m.id
where m.country in ( 'germany','Italy')
group by m.country;







-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select 
count(*) - count(id) as name_nulls, 
count(*) - count(height) as height_nulls, 
count(*) - count(date_of_birth) as date_of_birth_nulls, 
count(*) - count(known_for_movies) as known_for_movies_nulls 
from names;








/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with top_3_genres as
(select genre,
 count(m.id) as movie_count,
 rank() over (order by count(m.id) desc) as genre_rank
 from movie as m
 inner join genre as g on g.movie_id = m.id
 inner join ratings as r on r.movie_id = m.id
 where avg_rating > 8
 group by genre
 order by movie_count desc
 limit 3)
select n.name as director_name,
count(d.movie_id) as movie_count
from director_mapping as d
inner join genre g using (movie_id)
inner join names as n on n.id = d.name_id
inner join top_3_genres using (genre)
inner join ratings using (movie_id)
where avg_rating > 8
group by n.name
order by movie_count desc
limit 3;





/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select distinct n.name as actor_name ,
count(r.movie_id) as movie_count
from names as n
inner join role_mapping as rm
on rm.name_id = n.id
inner join ratings as r 
on rm.movie_id = r.movie_id
where r.median_rating >= 8 and rm.category = 'actor'
group by name
order by movie_count desc
limit 2;







/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


select production_company, sum(total_votes) as vote_count,
rank() over(order by sum(total_votes) desc) as prod_comp_rank
from movie as m
inner join ratings as r
on m.id = r.movie_id
group by production_company
limit 3;




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


select n.name as actor_name,
sum(r.total_votes) as total_votes,
count(distinct m.id) as movie_count,
round(sum(r.avg_rating * r.total_votes) / sum(r.total_votes), 2) as actor_avg_rating,
rank() over (order by round(sum(r.avg_rating * r.total_votes) / sum(r.total_votes), 2) desc, sum(r.total_votes) desc) as actor_rank
from names n
join role_mapping rm on rm.name_id = n.id
join movie m on m.id = rm.movie_id
join ratings r on r.movie_id = m.id
where rm.category = 'actor' and m.country = 'India'
group by n.name
having count(distinct m.id) >= 5
order by actor_rank ;






-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select n.name as actress_name, 
sum(total_votes) as total_votes, 
count(r.movie_id) as movie_count, 
round(sum(avg_rating*total_votes)/sum(total_votes), 2) as actress_avg_rating, 
rank() over (order by round(sum(avg_rating*total_votes)/sum(total_votes), 2) desc) as actress_rank 
from movie as m 
inner join ratings as r on m.id=r.movie_id 
inner join role_mapping as rm on m.id = rm.movie_id 
inner join names as n on rm.name_id = n.id 
where category = 'ACTRESS' and country = 'INDIA' and languages like '%HINDI%' 
group by n.name 
having movie_count >= 3 
limit 5;









/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
with thriller_movies as (
select distinct title,avg_rating
from movie as m
inner join ratings as r on r.movie_id=m.id
inner join genre as g on g.movie_id=m.id
where genre like 'THRILLER')
select *,
case
when avg_rating>8 then 'Superhit movies'
when avg_rating between 7 and 8 then 'Hit movies'
when avg_rating between 5 and 7 then 'One-time-watch movies'
else 'Flop movies'
end as avg_rating_category
from thriller_movies;







/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select genre,
round(avg(duration),2) as avg_duration,
sum(round(avg(duration),2)) over(order by genre rows unbounded preceding) as running_total_duration,
avg(round(avg(duration),2)) over(order by genre rows 10 preceding) as moving_avg_duration
from movie as m 
inner join genre as g 
on m.id = g.movie_id
group by genre
order by genre;









-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
with top_3_genre as(
select genre,
count(movie_id)as number_of_movies 
from genre as g 
inner join movie as m 
on g.movie_id=m.id 
group by genre 
order by count(movie_id)desc 
limit 3),
top_5 as(
select genre,
year,title as movie_name,
worlwide_gross_income,
rank()over(partition by year order by worlwide_gross_income desc)as movie_rank 
from movie as m 
inner join genre as g on m.id=g.movie_id 
where genre in (select genre from top_3_genre))
select *
from top_5 
where movie_rank<=5;










-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
select production_company,
count(m.id) as movie_count,
row_number() over(order by count(id) desc) as prod_comp_rank
from movie as m 
inner join ratings as r 
on m.id = r.movie_id
where median_rating >= 8 
and production_company is not null 
and position(',' in languages)>0
group by production_company
limit 2;





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with actress_summary as (
select n.name as actress_name,
sum(total_votes) as total_votes,
count(r.movie_id) as movie_count,
round(sum(avg_rating*total_votes)/sum(total_votes),2) as actress_avg_rating
from movie as m
inner join ratings as r on m.id=r.movie_id
inner join role_mapping as rm on m.id = rm.movie_id
inner join names as n on rm.name_id = n.id
inner join genre as g on g.movie_id = m.id
where category = 'ACTRESS'
and avg_rating > 8
and genre = 'Drama'
group by name)
select *,
rank() over(order by movie_count desc) as actress_rank
from actress_summary
limit 3;








/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
with next_date_published_summary as
(select d.name_id,
 name,
d.movie_id,
duration,
r.avg_rating,
total_votes,
m.date_published,
lead(date_published, 1) over(partition by d.name_id order by date_published, movie_id) as next_date_published
from director_mapping as d
inner join names as n
on n.id = d.name_id
inner join movie as m
on m.id = d.movie_id
inner join ratings as r
on r.movie_id = m.id), 
top_director_summary as
(select *,
datediff(next_date_published, date_published) as date_difference
from next_date_published_summary)
select name_id as director_id,
name as director_name,
count(movie_id) as number_of_movies,
round(avg(date_difference), 2) as avg_inter_movie_days,
round(avg(avg_rating), 2) as avg_rating,
sum(total_votes) as total_votes,
min(avg_rating) as min_rating,
max(avg_rating) as max_rating,
sum(duration) as total_duration
from top_director_summary
group by director_id
order by count(movie_id) desc
limit 9;







