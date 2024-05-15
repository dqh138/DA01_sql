--1
alter table public.sales_dataset_rfm_prj
alter column ordernumber type numeric using (trim(ordernumber)::numeric),
alter column QUANTITYORDERED type numeric using (trim(QUANTITYORDERED)::numeric),
alter column PRICEEACH type numeric using (trim(PRICEEACH)::numeric),
alter column orderlinenumber type numeric using (trim(orderlinenumber)::numeric),
ALTER column sales type numeric using (trim(sales)::numeric),
    ALTER column msrp type numeric using (trim(msrp)::numeric),
ALTER column orderdate type timestamp using (trim(orderdate)::timestamp)

--2
SELECT * from public.sales_dataset_rfm_prj
WHERE ordernumber IS NULL
or QUANTITYORDERED IS NULL
or PRICEEACH is null
or ORDERLINENUMBER is NULL
or SALES is NULL
or ORDERDATE is NULL

--3
Alter table public.sales_dataset_rfm_prj
add column first_name varchar(250),
add column last_name varchar(250);

UPDATE public.sales_dataset_rfm_prj
SET 
first_name = INITCAP(SUBSTRING(contactfullname FROM 1 FOR POSITION('-' IN contactfullname) - 1)),
last_name = INITCAP(SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname) + 1));

--4
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID INT,
ADD COLUMN MONTH_ID INT,
ADD COLUMN YEAR_ID INT;

UPDATE public.sales_dataset_rfm_prj
SET 
    QTR_ID = EXTRACT(QUARTER FROM ORDERDATE),
    MONTH_ID = EXTRACT(MONTH FROM ORDERDATE),
    YEAR_ID = EXTRACT(YEAR FROM ORDERDATE);

--5
--boxlot
with cte as (
select q1-1.5*IQR as min_val,
q3+1.5*IQR as max_val from (
select 
percentile_cont(0.25) within group (order by quantityordered) as q1,
percentile_cont(0.75) within group (order by quantityordered) as q3,
percentile_cont(0.75) within group (order by quantityordered) - percentile_cont(0.25) within group (order by quantityordered) as IQR

from public.sales_dataset_rfm_prj) as a)

Select * from public.sales_dataset_rfm_prj
where QUANTITYORDERED < (select min_val from cte)
or QUANTITYORDERED > (select max_val from cte)

--zscore
with cte as(
select QUANTITYORDERED,
(select avg(QUANTITYORDERED)from public.sales_dataset_rfm_prj) as avg1,
(select stddev(QUANTITYORDERED)
from public.sales_dataset_rfm_prj) as stddev
from public.sales_dataset_rfm_prj)
outlier as (
select QUANTITYORDERED, (QUANTITYORDERED-avg1)/stddev as z_score from cte
where abs((QUANTITYORDERED-avg1)/stddev)>3)

--delete
delete from public.sales_dataset_rfm_prj
where QUANTITYORDERED in (select QUANTITYORDERED from outlier)



