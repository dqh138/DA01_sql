--ex 1
Select b.Continent, Floor(avg(a.Population))
from city as a
join COUNTRY as b
on a.countrycode = b.code
group by b.Continent;
--ex2
with counts as (
select
  count(distinct e.user_id) as total_users,
  sum(case
    when signup_action = 'Confirmed' then 1
    else 0
  end) as confirmed_users
from emails e left join
texts t on t.email_id = e.email_id
)
select
round((cast(confirmed_users as decimal)/total_users),2) as confirm_rate
from counts
--ex3
WITH sending AS (
SELECT age_bucket,
a.user_id,
SUM(
CASE 
WHEN activity_type = 'open'
THEN time_spent
END) AS open_time, 
SUM(
CASE 
WHEN activity_type = 'send'
THEN time_spent
END) AS send_time,
SUM(time_spent) as total_time 

FROM activities as a
LEFT JOIN age_breakdown as b
on a.user_id = b.user_id
WHERE a.activity_type IN ('open','send')

GROUP BY age_bucket,a.user_id)

select 
age_bucket,
ROUND(((send_time/total_time)*100.0),2) as send_perc ,
ROUND(((open_time/total_time)*100.0),2) as open_perc 
 FROM sending;

--ex4
SELECT customer_id
FROM customer_contracts LEFT JOIN products 
ON customer_contracts.product_id = products.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT products.product_category) >= 3

--ex5
select e1.employee_id, e1.name, count(e2.employee_id) as reports_count, round(avg(e2.age)) as average_age
from Employees e1
Join Employees e2 
on e1.employee_id = e2.reports_to
group by e1.employee_id, e1.name
order by employee_id

