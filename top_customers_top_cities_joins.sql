-- Finds the top 5 highest-paying customers from the top 10 cities for Rockbuster.
SELECT A.customer_id,
A.first_name,
A.last_name,
C.city,
D.country,
SUM(E.amount) AS Total_amount_paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
WHERE C.city IN('Aurora', 'Atlixco', 'Xintai', 'Adoni',
'Dhule (Dhulia)', 'Kurashiki', 'Pingxiang', 'Sivas',
'Celaya', 'So Leopoldo')
GROUP BY A.customer_id,A.first_name,A.last_name,C.city,D.country
ORDER BY SUM(E.amount) DESC
LIMIT 5;
