-- EASY LEVEL QUESTIONS
-- Q1: who is the senior most employee based on job title
SELECT * from employee
ORDER BY levels desc
limit 1;

-- Q2: which countries have the most invoices?
SELECT * FROM invoice;
SELECT COUNT(*) as c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c desc;

-- Q3: what are top 3 values of total invoices?

SELECT total from invoice
ORDER BY total desc
LIMIT 3;

-- Q4 which city has the best customers? we would like to through a promotional music festival in the city we  made the most money. write the query that returns one city that has the highest sum of invoice total. return both the city name and sum of all invoice totals
select billing_city, sum(total) as sum
from invoice
GROUP BY billing_city
order by sum desc;

-- Q5: whos is the best customer ? the customer who has spent the most money will be declared the best customer. write a query for the person who has spent the most money 
select * from customer;
select * from invoice;

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total 
from customer 
JOIN invoice 
on customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY total desc
limit 1;

-- MODERATE LEVEL QUESTIONS
-- Q1: Write query to return the email, first name, last name & genre of all rock music listners. return your list ordered alphabetically by email starting with A 
SELECT * from genre;
SELECT DISTINCT email, first_name, last_name 
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line on invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
    SELECT track_id from track
    JOIN genre on track.genre_id = genre.genre_id
    WHERE genre.name LIKE 'Rock'
)
ORDER BY email;    

-- Q2: lets invite the artists who have written the most rock music in our dataset. Write a query that returns the artist name and total track count of the top 10 bands

SELECT ar.artist_id, ar.name, COUNT(ar.artist_id) as number_of_songs
FROM track as t
JOIN album2 as a ON  a.album_id = t.album_id
JOIN artist as ar ON ar.artist_id = a.artist_id
JOIN genre as g ON g.genre_id = t.genre_id
WHERE g.name LIKE 'Rock'
GROUP BY ar.artist_id, ar.name
ORDER BY number_of_songs DESC
LIMIT 10; 

-- Q3: Return all the track names that have a song lengt longer than the avg song length. return the name ans miliseconds for each track. order by the song lenght with the longest songs listed first

select name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) AS avg_track_length from track)
ORDER BY milliseconds desc;

SELECT AVG(milliseconds) from track;
select track.name, milliseconds
FROM track
WHERE milliseconds > 251177.7431
ORDER BY milliseconds desc;

-- HARDCORE LEVEL QUESTIONS
-- Q1: find how much amount spent by each customer on artists? write a query to return customer name, artist name and total spent


WITH best_selling_artist AS (
    SELECT 
        artist.artist_id AS artist_id, 
        artist.name AS artist_name,  
        SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
    FROM invoice_line
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN album2 ON album2.album_id = track.album_id
    JOIN artist ON artist.artist_id = album2.artist_id
    GROUP BY artist.artist_id, artist.name
    ORDER BY total_sales DESC
    LIMIT 1
)

SELECT 
    c.customer_id, c.first_name, c.last_name, bsa.artist_name,  
    SUM(il.unit_price * il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC;

-- Q2: We want to find out the most popular music genre for each country. we determine the most popular genre as the genre with the highest amount of purchases. write a query that returns each country along with the top genre. For countries where the maximum number od purchases is shared return all genres. 
