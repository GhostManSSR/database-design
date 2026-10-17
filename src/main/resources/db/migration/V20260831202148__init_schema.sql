CREATE SCHEMA IF NOT EXISTS library;

SET search_path TO library, public;

CREATE TYPE library.order_status AS ENUM (
    'Новый',
    'Оплачен',
    'Выполнен',
    'Отменен'
);

CREATE TABLE library.authors (
    author_id INTEGER NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE,
    country VARCHAR(100),

    CONSTRAINT pk_authors
        PRIMARY KEY (author_id)
);

CREATE TABLE library.publishers (
    publisher_id INTEGER NOT NULL,
    publisher_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,

    CONSTRAINT pk_publishers
        PRIMARY KEY (publisher_id),

    CONSTRAINT uq_publishers_name
        UNIQUE (publisher_name)
);

CREATE TABLE library.books (
    book_id INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20),
    publication_year INTEGER NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    publisher_id INTEGER NOT NULL,

    CONSTRAINT pk_books
        PRIMARY KEY (book_id),

    CONSTRAINT uq_books_isbn
        UNIQUE (isbn),

    CONSTRAINT chk_books_publication_year
        CHECK (publication_year BETWEEN 1750 AND 2026),

    CONSTRAINT chk_books_price
        CHECK (price > 0),

    CONSTRAINT chk_books_stock_quantity
        CHECK (stock_quantity >= 0),

    CONSTRAINT fk_books_publisher
        FOREIGN KEY (publisher_id)
            REFERENCES library.publishers (publisher_id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE library.book_authors (
    book_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,

    CONSTRAINT pk_book_authors
        PRIMARY KEY (book_id, author_id),

    CONSTRAINT fk_book_authors_book
        FOREIGN KEY (book_id)
            REFERENCES library.books (book_id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_book_authors_author
        FOREIGN KEY (author_id)
            REFERENCES library.authors (author_id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE library.customers (
    customer_id INTEGER NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT pk_customers
        PRIMARY KEY (customer_id),

    CONSTRAINT uq_customers_email
        UNIQUE (email),

    CONSTRAINT uq_customers_phone
        UNIQUE (phone)
);

CREATE TABLE library.employees (
    employee_id INTEGER NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    position VARCHAR(100) NOT NULL,
    salary NUMERIC(10, 2) NOT NULL,
    hire_date DATE NOT NULL,

    CONSTRAINT pk_employees
        PRIMARY KEY (employee_id),

    CONSTRAINT chk_employees_salary
        CHECK (salary > 0)
);

CREATE TABLE library.orders (
    order_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status library.order_status NOT NULL DEFAULT 'Новый',

    CONSTRAINT pk_orders
        PRIMARY KEY (order_id),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
            REFERENCES library.customers (customer_id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT,

    CONSTRAINT fk_orders_employee
        FOREIGN KEY (employee_id)
            REFERENCES library.employees (employee_id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

CREATE TABLE library.order_items (
    order_item_id INTEGER NOT NULL,
    order_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,

    CONSTRAINT pk_order_items
        PRIMARY KEY (order_item_id),

    CONSTRAINT uq_order_items_order_book
        UNIQUE (order_id, book_id),

    CONSTRAINT chk_order_items_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_items_unit_price
        CHECK (unit_price > 0),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id)
            REFERENCES library.orders (order_id)
            ON UPDATE CASCADE
            ON DELETE CASCADE,

    CONSTRAINT fk_order_items_book
        FOREIGN KEY (book_id)
            REFERENCES library.books (book_id)
            ON UPDATE CASCADE
            ON DELETE RESTRICT
);

-- CREATE INDEX idx_books_publisher
--     ON library.books (publisher_id);
--
-- CREATE INDEX idx_book_authors_author
--     ON library.book_authors (author_id);
--
-- CREATE INDEX idx_orders_customer
--     ON library.orders (customer_id);
--
-- CREATE INDEX idx_orders_employee
--     ON library.orders (employee_id);
--
-- CREATE INDEX idx_orders_date
--     ON library.orders (order_date);
--
-- CREATE INDEX idx_order_items_book
--     ON library.order_items (book_id);

