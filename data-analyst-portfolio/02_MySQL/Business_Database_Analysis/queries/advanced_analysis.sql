-- Advanced MySQL business analysis examples
-- MySQL 8.0+
-- Run after shop_schema_and_queries.sql has created and populated `shop`.

USE shop;

-- 1. Return every product tied for the second-highest distinct price.
WITH ranked_products AS (
    SELECT
        id,
        name,
        price,
        DENSE_RANK() OVER (ORDER BY price DESC) AS price_rank
    FROM products
)
SELECT id, name, price
FROM ranked_products
WHERE price_rank = 2;

-- 2. Rank products by price while keeping deterministic tie ordering.
SELECT
    id,
    name,
    price,
    RANK() OVER (ORDER BY price DESC) AS price_rank,
    ROW_NUMBER() OVER (ORDER BY price DESC, id) AS row_number_tiebreaker
FROM products;

-- 3. Monthly order count and month-over-month change.
WITH monthly_orders AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
),
with_previous AS (
    SELECT
        order_month,
        order_count,
        LAG(order_count) OVER (ORDER BY order_month) AS previous_order_count
    FROM monthly_orders
)
SELECT
    order_month,
    order_count,
    previous_order_count,
    order_count - previous_order_count AS absolute_change,
    ROUND(
        100.0 * (order_count - previous_order_count) / NULLIF(previous_order_count, 0),
        2
    ) AS percent_change
FROM with_previous
ORDER BY order_month;

-- 4. First and second order for each customer.
WITH sequenced_orders AS (
    SELECT
        cust_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY cust_id
            ORDER BY order_date, order_id
        ) AS order_sequence
    FROM orders
)
SELECT
    cust_id,
    MAX(CASE WHEN order_sequence = 1 THEN order_date END) AS first_order_date,
    MAX(CASE WHEN order_sequence = 2 THEN order_date END) AS second_order_date,
    DATEDIFF(
        MAX(CASE WHEN order_sequence = 2 THEN order_date END),
        MAX(CASE WHEN order_sequence = 1 THEN order_date END)
    ) AS days_to_second_order
FROM sequenced_orders
GROUP BY cust_id;

-- 5. Customers who never ordered. NOT EXISTS is null-safe.
SELECT c.cust_id, c.cust_name
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.cust_id = c.cust_id
);

-- 6. Customer spend, including customers with zero orders.
-- Limitation: the educational schema stores current product price, not price at order time.
SELECT
    c.cust_id,
    c.cust_name,
    COUNT(o.order_id) AS order_count,
    COALESCE(SUM(p.price), 0) AS modeled_spend
FROM customers AS c
LEFT JOIN orders AS o
    ON o.cust_id = c.cust_id
LEFT JOIN products AS p
    ON p.id = o.prod_id
GROUP BY c.cust_id, c.cust_name
ORDER BY modeled_spend DESC, c.cust_id;

-- 7. Product contribution and cumulative share of modeled order value.
WITH product_value AS (
    SELECT
        p.id,
        p.name,
        SUM(p.price) AS modeled_value
    FROM orders AS o
    JOIN products AS p
        ON p.id = o.prod_id
    GROUP BY p.id, p.name
),
contribution AS (
    SELECT
        id,
        name,
        modeled_value,
        SUM(modeled_value) OVER (
            ORDER BY modeled_value DESC, id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_value,
        SUM(modeled_value) OVER () AS total_value
    FROM product_value
)
SELECT
    id,
    name,
    modeled_value,
    ROUND(100.0 * modeled_value / NULLIF(total_value, 0), 2) AS value_share_pct,
    ROUND(100.0 * cumulative_value / NULLIF(total_value, 0), 2) AS cumulative_share_pct
FROM contribution
ORDER BY modeled_value DESC, id;

-- 8. Department salary ranking and distance from department average.
SELECT
    e.emp_id,
    e.emp_name,
    d.dept_name,
    e.salary,
    DENSE_RANK() OVER (
        PARTITION BY e.dept_id
        ORDER BY e.salary DESC
    ) AS salary_rank_in_department,
    ROUND(
        e.salary - AVG(e.salary) OVER (PARTITION BY e.dept_id),
        2
    ) AS difference_from_department_average
FROM employees AS e
JOIN departments AS d
    ON d.dept_id = e.dept_id
ORDER BY d.dept_name, salary_rank_in_department, e.emp_id;

-- 9. Payment history with running total per employee.
SELECT
    p.pay_id,
    p.emp_id,
    e.emp_name,
    p.pay_date,
    p.amount,
    SUM(p.amount) OVER (
        PARTITION BY p.emp_id
        ORDER BY p.pay_date, p.pay_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_amount_paid
FROM payments AS p
JOIN employees AS e
    ON e.emp_id = p.emp_id
ORDER BY p.emp_id, p.pay_date, p.pay_id;

-- 10. Data-quality checks for unexpected duplicates or broken references.
SELECT cust_id, prod_id, order_date, COUNT(*) AS duplicate_count
FROM orders
GROUP BY cust_id, prod_id, order_date
HAVING COUNT(*) > 1;

SELECT o.*
FROM orders AS o
LEFT JOIN customers AS c ON c.cust_id = o.cust_id
LEFT JOIN products AS p ON p.id = o.prod_id
WHERE c.cust_id IS NULL OR p.id IS NULL;

-- 11. Transaction demonstration: validate a change, then roll it back.
START TRANSACTION;

UPDATE employees AS e
JOIN departments AS d
    ON d.dept_id = e.dept_id
SET e.salary = e.salary * 1.05
WHERE d.dept_name = 'Sales';

SELECT e.emp_id, e.emp_name, d.dept_name, e.salary
FROM employees AS e
JOIN departments AS d ON d.dept_id = e.dept_id
WHERE d.dept_name = 'Sales';

ROLLBACK;

-- 12. Candidate indexes tied to demonstrated query patterns.
-- Check existing indexes before creating these in a real environment.
CREATE INDEX idx_orders_customer_date
    ON orders (cust_id, order_date, order_id);

CREATE INDEX idx_orders_product
    ON orders (prod_id);

CREATE INDEX idx_employees_department_salary
    ON employees (dept_id, salary);

CREATE INDEX idx_payments_employee_date
    ON payments (emp_id, pay_date, pay_id);

-- 13. Inspect whether the optimizer uses the customer/date index.
EXPLAIN ANALYZE
SELECT order_id, order_date, prod_id
FROM orders
WHERE cust_id = 1
  AND order_date >= '2024-01-01'
ORDER BY order_date, order_id;
