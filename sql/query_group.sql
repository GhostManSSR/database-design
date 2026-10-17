SELECT
    c.full_name AS customer_name,
    COUNT(o.order_id) AS orders_count
FROM library.customers c,
     library.orders o
WHERE o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) > 1
ORDER BY orders_count DESC, customer_name;

SELECT
    p.publisher_name,
    p.city,
    SUM(b.stock_quantity) AS total_stock
FROM library.publishers p,
     library.books b
WHERE b.publisher_id = p.publisher_id
GROUP BY p.publisher_id, p.publisher_name, p.city
ORDER BY total_stock DESC;