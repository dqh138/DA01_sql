--ex1
select name
from students
where marks > 75
order by right(name,3), id asc;
--ex2
select user_id, 
concat(upper (left(name,1)),lower(right(name, length(name)-1)))
as name
from Users
order by user_id;
--ex3
SELECT manufacturer, '$'||ROUND(sum(total_sales)/1000000) ||' '|| 'million' as sale 
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY sum(total_sales) desc, manufacturer ASC;
--ex4
SELECT 
EXTRACT(month from submit_date) as mth, 
product_id, 
round(avg(stars),2) as avg_stars
FROM reviews
GROUP BY EXTRACT(month from submit_date), product_id
ORDER By mth, product_id;

--ex5
SELECT sender_id, COUNT(message_id) as message_count
FROM messages
WHERE sent_date between '2022-08-01' and '2022-09-01'
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2;
--ex6
select tweet_id
from Tweets
where length(content) > 15 ;
--ex7
select activity_date as day, 
count(distinct user_id) as active_users
from Activity
group by activity_date
HAVING activity_date >= DATE_SUB('2019-07-27', INTERVAL 30 DAY)
--ex8
select count(id) as number_employees
from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date) = 2022;
--ex9
select position('a' in first_name)
from worker
where first_name = 'Amitah';
--ex10
select substring(title, length(winery)+2,4) from winemag_p2
where country = 'Macedonia';






