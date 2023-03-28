--BIC Data scientist case study--

-- Create table to test-- 

CREATE TABLE public.manufacturer (
    manufacturer_id text NOT NULL,
    manufacturer_name text NOT NULL
);


CREATE TABLE public.product (
    product_id integer NOT NULL,
    product_name text NOT NULL,
    avg_price integer
);

CREATE TABLE public.sales (
    manufacturer_id text NOT NULL,
    sold_date date NOT NULL,
    product_id integer NOT NULL
);

--Add id column for sales table--
ALTER TABLE public.sales
ADD COLUMN id serial;

--Add constraint and pk--

ALTER TABLE ONLY public.manufacturer
    ADD CONSTRAINT manufacturer_pkey PRIMARY KEY (manufacturer_id);
	
ALTER TABLE ONLY public.product
    ADD CONSTRAINT product_pkey PRIMARY KEY (product_id);
	
ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);
	
	
--Create relationship--
ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturer(manufacturer_id);
	

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.product(product_id);


-- 1. What is the total sales for each manufacturer in the year 2020?--
select manufacturer_id, count(*) from public.sales
where extract(year from sold_date) = '2020'
group by manufacturer_id;

--OR 

select manufacturer_id, count(*) from public.sales
where sold_date <= date'2020-12-31'
and sold_date >= date '2020-01-01'
group by manufacturer_id;

-- 2. What is the most purchased product and how many times was it purchased in the year 2021?

select s.product_id, count(s.product_id) as mycount from public.sales s
left join public.product p on p.product_id = s.product_id
where s.sold_date <= date '2021-12-31'
and s.sold_date >= date '2021-01-01'
group by s.product_id
order by mycount desc
limit 1


-- 3. What is the percentage change in the BIC’s sales compared to previous year?
-- Percentage change = ((V2 - V1) / V1 ) * 100

WITH CTE AS (
	SELECT
		extract(year from s.sold_date) as year,
		count(*) as amount
		from public.sales s
		left join public.manufacturer m on m.manufacturer_id = s.manufacturer_id
		where m.manufacturer_name = 'BIC'
		group by year
		order by year
		)
	SELECT
	year,
	amount,
	round(( (cast(amount as float) - LAG(amount, 1) OVER (ORDER BY year)) / LAG(amount, 1) OVER (ORDER BY year)) * 100) as result
	from
	CTE
	order by result asc
	limit 1
	
	
	
-- 4. Is there growth in BIC Stationery sales compared to last year?

WITH CTE AS (
	SELECT
	extract(year from s.sold_date) as year,

	count(*) as amount
	from public.sales s
	left join public.manufacturer m on m.manufacturer_id = s.manufacturer_id
	left join public.product p on p.product_id = s.product_id
	where m.manufacturer_name = 'BIC'
	and p.product_name = 'Stationery'
	group by year
	order by year
	)
	
	select
	year,
	amount,
	round(( (cast(amount as float) - LAG(amount, 1) OVER (ORDER BY year)) / LAG(amount, 1) OVER (ORDER BY year)) * 100) as result
	from
	CTE
	order by result asc
	limit 1
