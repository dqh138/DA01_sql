--ex1
select distinct city
from station
where id%2 = 0;
--ex2
select count(city) - count(distinct city)
from station;
--ex3
select ceiling (avg(salary) - avg(REPLACE(salary,0, '')))
from employees;
--ex4
SELECT ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) as decimal), 1) as mean
FROM items_per_order;
--ex5
select candidate_id
FROM candidates
where  skill in('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING Count(skill)=3
ORDER BY candidate_id ASC;
--ex6
SELECT user_id, 
Date(max(post_date))- date(min(post_date)) as days_between
FROM posts
WHERE post_date >= '2021-01-01' AND post_date <= '2022-01-01'
GROUP BY user_id
HAVING COUNT(user_id) > 1;
--ex7
SELECT card_name,
Max(issued_amount)-min(issued_amount) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;
--ex8
SELECT manufacturer, 
count(drug) as drug_count,
SUM(cogs - total_sales) as total_loss
from pharmacy_sales
WHERE cogs>total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;
--ex9
select id, movie, description, rating
from cinema
where id%2 = 1
and description <> 'boring'
order by rating desc;
--ex10
select teacher_id,
count(distinct subject_id) as cnt
from teacher
group by teacher_id;
--ex11
select user_id,
count(follower_id) as followers_count
from followers
group by user_id
order by user_id asc;
--ex12
select class
from Courses
Group by class
having count(student) >=5;

