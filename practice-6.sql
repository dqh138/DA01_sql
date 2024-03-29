--ex1
with com 
AS (
SELECT title, description, company_id
FROM job_listings
group by title, description, company_id
having COUNT(*) >= 2)
SELECT COUNT(company_id) FROM com as duplicate_companies
--ex2
WITH category_total_spend AS (
    SELECT 
        category, 
        SUM(spend) AS total_category_spend
    FROM 
        product_spend
    WHERE 
        EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY 
        category
)
SELECT 
    ps.category, 
    ps.product, 
    ps.total_spend 
FROM 
    product_spend AS ps
JOIN 
    category_total_spend AS cts ON ps.category = cts.category
JOIN (
    SELECT 
        category, 
        RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking
    FROM 
        product_spend
    WHERE 
        EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY 
        category, product
) ranked_spending_cte ON ps.category = ranked_spending_cte.category
                       AND ps.total_spend = cts.total_category_spend
WHERE 
    ranked_spending_cte.ranking <= 2
ORDER BY 
    ps.category, 
    ranked_spending_cte.ranking;
--ex3
WITH call_records AS (
SELECT
  policy_holder_id,
  COUNT(case_id) AS call_count
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3
)
SELECT COUNT(policy_holder_id) AS member_count
FROM call_records;
--ex4
SELECT a.page_id
FROM pages as a 
LEFT JOIN page_likes as b 
ON a.page_id = b.page_id
WHERE b.liked_date is NULL
ORDER BY a.page_id ASC
--ex5
WITH active_user AS (
SELECT DISTINCT a.user_id, a.event_type, EXTRACT(month FROM a.event_date) as mth
FROM user_actions AS a
JOIN user_actions AS b 
on b.user_id = a.user_id
WHERE EXTRACT('MONTH' FROM b.event_date) = EXTRACT('MONTH' FROM a.event_date) -1
and EXTRACT('MONTH' FROM a.event_date) = 7
GROUP BY a.user_id, a.event_type, EXTRACT(month FROM a.event_date)
HAVING a.event_type IN (a.event_type)
)
SELECT mth,
COUNT(DISTINCT user_id) AS monthly_active_users FROM active_user 
GROUP BY mth;

--ex6
SELECT  DATE_FORMAT(trans_date, '%Y-%m') as month, country, count(id) as trans_count, 
SUM(CASE WHEN state = 'approved' then 1 else 0 END) as approved_count, 
SUM(amount) as trans_total_amount, 
SUM(CASE WHEN state = 'approved' then amount else 0 END) as approved_total_amount
FROM Transactions
GROUP BY month, country

--ex7
with cte1 as (
SELECT
 product_id, quantity,
 MIN(year) AS first_year
FROM Sales as s
GROUP BY product_id
)

Select cte1.product_id, cte1.first_year, cte1.quantity, s.price
from Sales as s
join cte1
on s.product_id = cte1.product_id
join Product as p
group by s.product_id
order by s.product_id

--ex8
with cte as(
select count(product_key) as ct from Product
)
select customer_id from Customer 
group by customer_id
having count(distinct product_key) = (SELECT ct FROM cte)

--ex9
select employee_id from Employees
where salary < 30000
and manager_id is not null
and manager_id not in (select employee_id from Employees);

--ex10
WITH com_count AS (
SELECT title, description, company_id
FROM job_listings
group by title, description, company_id
having COUNT(*) >= 2
)
SELECT COUNT(DISTINCT company_id) FROM com_count
AS duplicate_companies
    
--ex11
(select u.name as results
from Users as u
inner join MovieRating as movie
on u.user_id = movie.user_id
group by u.user_id
order by count(movie.user_id) desc, u.name asc
limit 1)

union all
(
select m.title as results
from Movies as m
join MovieRating as movie
on m.movie_id = movie.movie_id
where extract(year_month from created_at) = 202002
group by m.title
order by avg(movie.rating) DESC,  m.title ASC 
limit 1
)

--ex12
with cte as (
select requester_id as id from RequestAccepted
union all
select accepter_id as id from RequestAccepted
)
select id, count(*) as num from cte
group by id
order by num desc
limit 1





