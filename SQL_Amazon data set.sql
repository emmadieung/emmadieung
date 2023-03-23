--CREATE SALES AMAZON TABLE AND IMPORT DATA FROM CSV FILE--

CREATE TABLE emmanguyen.amazondata 
(
	product_id varchar,
	product_name varchar,
	category varchar,
	discounted_price varchar,
	actual_price varchar,
	discount_percentage varchar,
	rating varchar, 
	rating_count varchar,
	about_product varchar,
	user_id varchar,
	user_name varchar,
	review_id varchar,
	review_title varchar,
	review_content varchar,
	img_link varchar,
	product_link varchar)
	;
	
SELECT * FROM emmanguyen.amazondata;

	
--create table amazon_sales from existing table amazondata--
	
create table emmanguyen.amazon_sales as
select
	product_id,
	right(discounted_price, length(discounted_price)-1) as disc_price, 
	right(actual_price, length(actual_price)-1) as price,
	discount_percentage,
	rating,
	rating_count
from emmanguyen.amazondata;

--ADD PK--

alter table emmanguyen.amazon_sales add productID SERIAL;
alter table emmanguyen.amazon_sales add primary key(productID);

--REPLACE VALUE--
update emmanguyen.amazon_sales 
set disc_price = replace(disc_price,',','');

update emmanguyen.amazon_sales
set price = replace(price,',','');

update emmanguyen.amazon_sales 
set rating_count = replace(rating_count,',','');

update emmanguyen.amazon_sales 
set discount_percentage = left(discount_percentage, length(discount_percentage)-1);


--CHANGE TYPE OF COLUMN--

alter table emmanguyen.amazon_sales
alter column disc_price type decimal using disc_price::decimal;

alter table emmanguyen.amazon_sales
alter column price type decimal using price::decimal,
alter column discount_percentage type decimal using discount_percentage::decimal,
alter column rating_count type decimal using rating_count::int;

select * from emmanguyen.amazon_sales;


--create amazon_product table--

create table emmanguyen.amazon_product as
	select 
		product_id,
		product_name,
		category,
		about_product,
		img_link,
		product_link
	from emmanguyen.amazondata;

select * from emmanguyen.amazon_product;

--create table amazon_review from amazondata table--

create table emmanguyen.amazon_review as
	select 
		user_id,
		user_name,
		review_id,
		review_title,
		review_content,
		product_id
	from emmanguyen.amazondata;

select * from emmanguyen.amazon_review;

