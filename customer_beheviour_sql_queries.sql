use customer_beheviour;
select * from customer;
-- 1-what is the total revenue genarated by male vs female customers?
select gender,sum(purchase_amount) as revenue
from customer
group by gender;
-- 2-which customer used a discount but stil spent more than the average purachase amount?
select customer_id,purchase_amount 
from customer where discount_applied="yes" and
purchase_amount>=(select avg(purchase_amount) from customer);
-- 3-which are the top 5 products with the highest average review rating?

select item_purchased,ROUND(AVG(review_rating), 2) AS "Average Product Rate"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

-- -4 compare the average purchase amounts between standards and express shipping?
select shipping_type,avg(purchase_amount)
from customer
where shipping_type in ('Standard','Express') 
group by shipping_type;

-- -5 do subscribed customer spend more ?compare average spend and total
-- revenue between subscribers and non-subscribers. 
select subscription_status, count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue 
from customer group by subscription_status
order by total_revenue,avg_spend desc;
-- 6- which 5 product have the highest percentage of purchases with
-- discounts applied?
SELECT item_purchased,
       ROUND(
           100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*),
           2
       ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- 7- segment customers into new ,returning, and loyal based on theri
-- total number of previous purchases and show the count of each segment??
 with customer_type as (
 select customer_id,previous_purchases,
 case when previous_purchases=1 then 'New'
      when previous_purchases between 2 and 10 then 'Returning'
 else 'Loyal'
 end as customer_segment
 from customer
 ) 
 select customer_segment,count(*) as "number of customers"
 from customer_type
 group by customer_segment;
 -- 8- what are the top 3 most purchased products within each category?
WITH item_count AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT 
    item_rank,
    category,
    item_purchased,
    total_orders
FROM item_count
WHERE item_rank <= 3;

-- 9- are customers who are repeat buyers (more than 5 previous purchases)
-- also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer where previous_purchases >5
group by subscription_status;
-- 10- what is the revenue contribution of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;







