create database sql_pro1;
use sql_pro1;
CREATE TABLE sale(
transactions_id INT primary KEY,
sale_date date,
sale_time time,
customer_id INT,
gender varchar(15),
age int,
category varchar(15),
quantiy INT,
price_per_unit int,
cogs FLOAT,
total_sale FLOAT
);

-- start practices

select * from sale
where 
transactions_id is null
OR
 sale_date is null
OR
 sale_time is null
OR
 customer_id is null
OR
 gender is null
OR
 age is null
OR
 category is null
OR
 quantiy is null
OR
 price_per_unit is null
OR
 cogs is null
OR
 total_sale is null;

-- uniqe(distinct) coustomer

select count(distinct customer_id) as total_sale from sale;

-- data analysis question

select * from sale
where sale_date = "2022-11-05";

-- another question

	select
			* from sale
			where category = 'clothing'
			AND
			sale_date>='2022-11-1'
			AND
			sale_date<'2022-12-1'
			AND 
			quantiy >=4;
    
    -- write a quarry to calculate the total sale for each catogor
    
    select 
		category,sum(total_sale) as net_sale,
		count(*) as total_order
		from sale
		group by 1;
		
    -- average age of coustomer who purchase item from the 'beauty' iteam.
    
    select
		ROUND(avg(age),2), category from sale
		where category = 'Beauty';
		
    -- write a sql to find all transaction where the total_sale is grater then 1000
    
    select
		* from sale
		where total_sale >= '1000';
		
-- write a sql query to find total number of transaction(transaction_id) made by each gender in each catogry 

select 
	category,
	 gender, count(*)as total_trnsa
	 from sale
	GROUP BY 
	category, gender;

-- write sql query to calculate the average sale for each month. find out best selling month in each year

select
	year,month,
    avg_sale
    from
    (
select 
	extract(year from sale_date ) as year,
	extract(month from sale_date ) as month,
	ROUND(AVG(total_sale),2) as avg_sale,
	RANK() over(PARTITION BY extract(year from sale_date ) ORDER BY ROUND(AVG(total_sale)) DESC) AS rnk
	from sale
	group by 1,2)
	as t1
	where rnk=1;

-- sql query fo find top 5 coustomer based on the highest total sales 

select
	 customer_id,
	sum(total_sale) from sale
	group by 1
	order by 2 desc
	limit 5;

-- write a query  to find the number of unque coustomer who purchase iatem from each

SELECT 
		 category,
		 count(DISTINCT customer_id) as uniqe_costmer
		 from sale
		 group by category;
		 
 -- write a query  to create each shift and number of order example(morning <=12 ,afternoon b/w 12 &17, evening>17)
 
 with hour_sale
 AS
 (
	select *, 
		case 
		when EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning'
		 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN  12 AND 17 THEN 'afternoon'
		ELSE 'evening'
		END as shift
		FROM sale
 )
 select 
	shift,
	count(*) as total_sale
	from hour_sale
	group by shift;