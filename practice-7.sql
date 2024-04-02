--ex1
WITH yearly AS(
SELECT 
EXTRACT(year from transaction_date) as yr,
product_id,
spend AS curr_year_spend,
lag(spend)OVER(PARTITION BY product_id ORDER BY EXTRACT(year from transaction_date)) as prev_year_spend
FROM user_transactions
)
SELECT
yr,
product_id,
curr_year_spend,
prev_year_spend,
ROUND(((curr_year_spend/prev_year_spend)-1)*100,2) as yoy_rate
FROM yearly;

--ex2
WITH ranking as (
SELECT card_name, issued_amount,
RANK()OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) as rankk
FROM monthly_cards_issued
)

SELECT card_name, issued_amount
FROM ranking
WHERE rankk = 1
ORDER BY issued_amount DESC;

--ex3
WITH stt as (
SELECT user_id, spend, transaction_date, 
RANK()OVER(PARTITION BY user_id ORDER BY transaction_date) as rankk
FROM transactions
)
SELECT user_id, spend, transaction_date
FROM stt 
WHERE rankk = 3

--ex4
WITH latest AS (
SELECT
transaction_date,
user_id,
product_id,
RANK()OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS txs_rank
FROM user_transactions
)
SELECT transaction_date, user_id,
COUNT(product_id) AS purchase_amount
FROM latest
WHERE txs_rank =1 
GROUP BY transaction_date, user_id
ORDER BY transaction_date

--ex5
select user_id,tweet_date,
ROUND(AVG(tweet_count) OVER(PARTITION BY user_id ORDER BY tweet_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
AS rolling_avg_3d
from tweets;

--ex6
with cte AS (
SELECT merchant_id, credit_card_id , amount, row_number()over(partition by merchant_id, credit_card_id, amount order by transaction_timestamp) as tt ,
transaction_timestamp, lead(transaction_timestamp)over(PARTITION BY merchant_id) as next_trans
from transactions
)
select count(merchant_id) as payments_count
from  cte  
where tt>1 and transaction_timestamp-next_trans<= INTERVAL '10 minutes';

--ex7
WITH cte AS(
SELECT
 category,
 product,
 SUM(spend) AS total_spend,
 RANK() OVER(PARTITION BY category ORDER BY SUM(spend) DESC) as rankk
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product
)
SELECT category, product, total_spend
FROM cte WHERE rankk <=2;

--ex8
WITH cte as (

SELECT a.artist_name,
DENSE_RANK()OVER(ORDER BY COUNT(g.song_id) DESC) AS artist_rank
FROM artists as a  
JOIN songs as s 
ON a.artist_id=s.artist_id
JOIN global_song_rank AS g  
ON s.song_id=g.song_id
WHERE g.rank <= 10
GROUP BY a.artist_name
)
SELECT artist_name, artist_rank
from cte 
WHERE artist_rank <=5
;





