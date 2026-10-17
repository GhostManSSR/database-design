SELECT
    o.order_id,
    o.order_date,
    c.full_name AS customer_name,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM library.orders o
         JOIN library.customers c
              ON c.customer_id = o.customer_id
         JOIN library.order_items oi
              ON oi.order_id = o.order_id
GROUP BY o.order_id, o.order_date, c.full_name
ORDER BY o.order_date DESC;

SELECT
    b.title AS book_title,
    a.full_name AS author_name,
    p.publisher_name,
    b.price
FROM library.books b
         JOIN library.book_authors ba
              ON ba.book_id = b.book_id
         JOIN library.authors a
              ON a.author_id = ba.author_id
         JOIN library.publishers p
              ON p.publisher_id = b.publisher_id
ORDER BY b.title, author_name;