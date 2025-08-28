-- Aggregates the top 5 customers by country to show their distribution across regions
--top 10 countries by customer count
WITH top_countries AS(
SELECT d.country, COUNT(a.customer_id) AS customer_count_by_country
FROM customer a
INNER JOIN address b ON a.address_id = b.address_id
INNER JOIN city c ON b.city_id = c.city_id
INNER JOIN country d ON c.country_id = d.country_id
GROUP BY d.country
ORDER BY customer_count_by_country DESC
LIMIT 10
),
--top 10 cities within top countries by customer count
top_cities AS(
SELECT e.city,tc.country,COUNT(a1.customer_id) AS customer_count_by_city
FROM customer a1
INNER JOIN address f ON a1.address_id = f.address_id
INNER JOIN city e ON f.city_id = e.city_id
INNER JOIN country d ON e.country_id = d.country_id
INNER JOIN top_countries tc ON d.country = tc.country
GROUP BY e.city,tc.country
ORDER BY customer_count_by_city DESC
LIMIT 10
),
-- Get top 5 customers based on total amount paid within 10 top cities
top_customers_by_amount AS(
SELECT a2.customer_id,a2.first_name,a2.last_name,e1.city,d1.country,SUM(p.amount) AS total_amount
FROM customer a2
INNER JOIN payment p ON a2.customer_id = p.customer_id
INNER JOIN address f1 ON a2.address_id = f1.address_id
INNER JOIN city e1 ON f1.city_id = e1.city_id
INNER JOIN top_cities tc1 ON e1.city = tc1.city
INNER JOIN country d1 ON e1.country_id = d1.country_id
INNER JOIN top_countries tc2 ON d1.country = tc2.country
GROUP BY a2.customer_id,a2.first_name,a2.last_name,e1.city,d1.country
ORDER BY total_amount DESC
LIMIT 5),
--count how many of those top 5 customers are in each country?
top_customers_by_country AS (
SELECT a3.customer_id,a3.first_name,a3.last_name,d2.country,COUNT(a3.customer_id) AS total_customer_count
FROM customer a3
INNER JOIN address f2 ON a3.address_id = f2.address_id
INNER JOIN city e2 ON f2.city_id = e2.city_id
INNER JOIN country d2 ON e2.country_id = d2.country_id
INNER JOIN top_customers_by_amount tc3 ON a3.customer_id = tc3.customer_id
GROUP BY a3.customer_id,a3.first_name,a3.last_name,d2.country
ORDER BY total_customer_count DESC)
SELECT d3.country,
COUNT(DISTINCT a4.customer_id) AS all_customer_count,
COUNT(DISTINCT tcc.customer_id) AS top_customer_count
FROM customer a4
INNER JOIN address f3 ON a4.address_id = f3.address_id
INNER JOIN city e3 ON f3.city_id = e3.city_id
INNER JOIN country d3 ON e3.country_id = d3.country_id
LEFT JOIN top_customers_by_country tcc ON a4.customer_id = tcc.customer_id
GROUP BY d3.country
ORDER BY all_customer_count DESC, top_customer_count DESC
LIMIT 5;
