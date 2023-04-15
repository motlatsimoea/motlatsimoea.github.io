describe customers;
describe Markets;
desc transactions;

-- Inspect the data in each table
select *  
from transactions
limit 5;

-- There are some Sales_amount values that are "-1". This is obviously incorrect. This must be fixed before any serious Analysis.

select * from markets;
select * from customers;

select * from products;

select distinct product_type  
from products;

select *  
from transactions
where market_code = 'Mark001';

select *  
from transactions
where currency = 'USD';

-- The Fact that there are two USD values means there is a problem there. Some data cleaning is necessary here.

select distinct currency 
from transactions;

-- The INR values also have two values. Again, this means that there needs to be some data cleaning here.

-- Let's Join some tables and have some fun with it.
select t.*, c.*
from transactions t inner join customers c
on c.customer_code = t.customer_code
where customer_type = 'Brick & Mortar';

select sum(sales_amount) Total_Sales
from transactions t inner join customers c
on c.customer_code = t.customer_code
where custmer_name = 'Premium Stores';

-- Working with Joint tables to use Date Table for date references.
select t.*, d.*
from transactions t inner join date d
on t.order_date = d.date
where d.year = 2020;

-- Total revenues by Year and market code
select sum(sales_amount) Total_Revenue
from transactions t inner join date d
on t.order_date = d.date
where d.year = 2017
and market_code = 'Mark001';

-- GROUP BY
select * from transactions;
select market_code, sum(sales_qty) Sales_Quantity, sum(sales_amount) Sales_Amount
from transactions
group by market_code;	


-- Let's Partition data by something
select sales_amount, product_code, 
sum(sales_amount) over (partition by product_code) Total_Product_code_sales
from transactions t inner join date d
on t.order_date = d.date;

select sales_amount, product_code, 
max(sales_amount) over (partition by product_code) Total_Product_code_sales
from transactions t inner join date d
on t.order_date = d.date;


-- CUME_DIST() AND PERCENT_RANK()
select product_code, sales_qty, market_code,
cume_dist() over (partition by product_code order by sales_qty) as cum_value,
percent_rank() over (partition by product_code order by sales_qty) as relative_rank
from transactions;

select product_code, market_code, sales_amount,
cume_dist() over (partition by product_code order by sales_amount) as cum_value,
percent_rank() over (partition by product_code order by sales_amount) as relative_rank
from transactions;

-- Using CTE to calculate percentages Window Function
SELECT sales_amount, product_code, 
sum(sales_amount) over (partition by product_code) Total_Product_code_sales, (sales_amount/Total_Product_code_sales) Percent
FROM transactions t INNER JOIN date d
on t.order_date = d.date;


WITH percent_cte (sales, codes, Total)
AS 
(
select sales_amount, product_code, 
sum(sales_amount) over (partition by product_code) Total_Product_code_sales
from transactions t inner join date d
on t.order_date = d.date
)
select sales, codes, Total, (sales/Total)*100 Percentage
from percent_cte;


-- SUBQUERY AND JOINS
SELECT market_code, sum(sales_qty) as sales_quantity
FROM transactions
GROUP BY market_code; 

SELECT avg(sales_quantity) as avg_quantity
FROM
(
SELECT market_code, sum(sales_qty) as sales_quantity
FROM transactions
GROUP BY market_code
) x;




select *
from 
	(select market_code, sum(sales_qty) as Sales_Quantity
	 from transactions
	 group by market_code) quantity
join 
	(select avg(Sales_Quantity) as quantity
	 from	
	 (select market_code, sum(sales_qty) as Sales_Quantity
	  from transactions
	  group by market_code) q) avg_Quantity
on quantity.Sales_Quantity >  avg_Quantity.quantity;   


