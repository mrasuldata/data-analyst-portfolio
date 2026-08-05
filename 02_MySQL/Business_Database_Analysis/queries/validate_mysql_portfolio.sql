-- Automated validation for the data analyst portfolio MySQL projects.
-- Run after all supplied setup and analysis scripts.

SELECT '=== BUSINESS_PEOPLE VALIDATION ===' AS validation_section;

SELECT
    'business_people.employee_count' AS check_name,
    COUNT(*) AS actual_value,
    14 AS expected_value,
    IF(COUNT(*) = 14, 'PASS', 'FAIL') AS status
FROM business_people.emp;

SELECT
    'business_people.department_count' AS check_name,
    COUNT(*) AS actual_value,
    4 AS expected_value,
    IF(COUNT(*) = 4, 'PASS', 'FAIL') AS status
FROM business_people.dept;

SELECT
    'business_people.distinct_designations' AS check_name,
    COUNT(DISTINCT job) AS actual_value,
    5 AS expected_value,
    IF(COUNT(DISTINCT job) = 5, 'PASS', 'FAIL') AS status
FROM business_people.emp;

SELECT
    'business_people.total_salary' AS check_name,
    CAST(SUM(sal) AS DECIMAL(12,2)) AS actual_value,
    CAST(29025.00 AS DECIMAL(12,2)) AS expected_value,
    IF(SUM(sal) = 29025.00, 'PASS', 'FAIL') AS status
FROM business_people.emp;

SELECT
    'business_people.king_present' AS check_name,
    COUNT(*) AS actual_value,
    1 AS expected_value,
    IF(COUNT(*) = 1, 'PASS', 'FAIL') AS status
FROM business_people.emp
WHERE empno = 7839 AND ename = 'KING';

SELECT '=== SHOP VALIDATION ===' AS validation_section;

SELECT
    'shop.product_count' AS check_name,
    COUNT(*) AS actual_value,
    4 AS expected_value,
    IF(COUNT(*) = 4, 'PASS', 'FAIL') AS status
FROM shop.products;

SELECT
    'shop.customer_count' AS check_name,
    COUNT(*) AS actual_value,
    3 AS expected_value,
    IF(COUNT(*) = 3, 'PASS', 'FAIL') AS status
FROM shop.customers;

SELECT
    'shop.order_count' AS check_name,
    COUNT(*) AS actual_value,
    3 AS expected_value,
    IF(COUNT(*) = 3, 'PASS', 'FAIL') AS status
FROM shop.orders;

SELECT
    'shop.employee_count' AS check_name,
    COUNT(*) AS actual_value,
    4 AS expected_value,
    IF(COUNT(*) = 4, 'PASS', 'FAIL') AS status
FROM shop.employees;

SELECT
    'shop.payment_count' AS check_name,
    COUNT(*) AS actual_value,
    4 AS expected_value,
    IF(COUNT(*) = 4, 'PASS', 'FAIL') AS status
FROM shop.payments;

SELECT
    'shop.orphan_order_count' AS check_name,
    COUNT(*) AS actual_value,
    0 AS expected_value,
    IF(COUNT(*) = 0, 'PASS', 'FAIL') AS status
FROM shop.orders AS o
LEFT JOIN shop.customers AS c
    ON c.cust_id = o.cust_id
LEFT JOIN shop.products AS p
    ON p.id = o.prod_id
WHERE c.cust_id IS NULL OR p.id IS NULL;

SELECT
    'shop.advanced_index_count' AS check_name,
    COUNT(DISTINCT index_name) AS actual_value,
    4 AS expected_value,
    IF(COUNT(DISTINCT index_name) = 4, 'PASS', 'FAIL') AS status
FROM information_schema.statistics
WHERE table_schema = 'shop'
  AND index_name IN (
      'idx_orders_customer_date',
      'idx_orders_product',
      'idx_employees_department_salary',
      'idx_payments_employee_date'
  );

SELECT '=== VALIDATION COMPLETE ===' AS validation_section;
