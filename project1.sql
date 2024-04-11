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


