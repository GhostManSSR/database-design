CREATE OR REPLACE VIEW library.v_order_details AS
SELECT
    o.order_id,
    c.full_name AS customer_name,
    e.full_name AS employee_name,
    o.order_date,
    o.status,
    COUNT(oi.order_item_id) AS items_count
FROM library.orders o
         JOIN library.customers c
              ON c.customer_id = o.customer_id
         JOIN library.employees e
              ON e.employee_id = o.employee_id
         JOIN library.order_items oi
              ON oi.order_id = o.order_id
GROUP BY
    o.order_id,
    c.full_name,
    e.full_name,
    o.order_date,
    o.status;



CREATE OR REPLACE VIEW library.v_books_with_authors AS
SELECT
    b.book_id,
    b.title AS book_title,
    p.publisher_name,
    b.price,
    COUNT(ba.author_id) AS authors_count,
    CASE
        WHEN b.price > (
            SELECT AVG(price)
            FROM library.books
        ) THEN TRUE
        ELSE FALSE
        END AS is_above_average_price
FROM library.books b
         JOIN library.publishers p
              ON p.publisher_id = b.publisher_id
         JOIN library.book_authors ba
              ON ba.book_id = b.book_id
GROUP BY
    b.book_id,
    b.title,
    p.publisher_name,
    b.price;