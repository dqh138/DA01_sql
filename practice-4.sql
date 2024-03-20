--ex1
SELECT
  COUNT(CASE WHEN device_type = 'laptop' THEN 'laptop_view' END) AS laptop_view,
  COUNT(CASE WHEN device_type IN ('tablet','phone') THEN 'mobile_view' END) AS movile_views
FROM viewership;
--ex2
select x,y,z, 
case
when X+Y>Z and X+Z>Y and Y+Z>X then 'Yes'
else 'No'
end triangle
from Triangle;
--ex3
SELECT 
SUM(CASE
WHEN call_category is NULL or call_category = 'n/a' then 1
else 0
END) as null_values,
COUNT(case_id) as total_call,
ROUND(100* SUM(CASE
WHEN call_category is NULL or call_category = 'n/a' then 1
else 0
END)/COUNT(case_id),1) as call_percent
FROM callers;
--ex4
SELECT name
FROM Customer
WHERE COALESCE(referee_id,0) <> 2;
--ex5
select survived,
count(case
when
pclass = 1 then 'first_class'
end) as total_first,
count(case
when
pclass = 2 then 'second_class'
end) as total_second,
count(case
when
pclass = 3 then 'third_class'
end) as total_third
from titanic
group by survived;
