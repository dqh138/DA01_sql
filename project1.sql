--1
alter table public.sales_dataset_rfm_prj
alter column orderlinenumber type numeric using (trim(orderlinenumber)::numeric),
ALTER column sales type numeric using (trim(sales)::numeric),
ALTER column mspr type numeric using (trim(mspr)::numeric),
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

