USE business_people;

-- 1. Analysts and salesmen
SELECT ename, job FROM emp WHERE job IN ('ANALYST', 'SALESMAN');

-- 2. Employees hired before 30 September 1981
SELECT * FROM emp WHERE hiredate < '1981-09-30';

-- 3. Employees who are not managers
SELECT ename, job FROM emp WHERE job <> 'MANAGER';

-- 4. Requested employee numbers
SELECT empno, ename FROM emp WHERE empno IN (7369, 7521, 7839, 7934, 7788);

-- 5. Employees outside departments 30, 40, and 10
SELECT ename, deptno FROM emp WHERE deptno NOT IN (30, 40, 10);

-- 6. Employees hired from 30 June through 31 December 1981
SELECT ename, hiredate FROM emp WHERE hiredate BETWEEN '1981-06-30' AND '1981-12-31';

-- 7. Distinct designations
SELECT DISTINCT job AS designation FROM emp ORDER BY designation;

-- 8. Employees not eligible for commission
SELECT ename FROM emp WHERE comm IS NULL OR comm = 0;

-- 9. Employee who reports to nobody
SELECT ename, job AS designation FROM emp WHERE mgr IS NULL;

-- 10. Employees without a department
SELECT ename FROM emp WHERE deptno IS NULL;

-- 11. Employees eligible for commission
SELECT ename, comm FROM emp WHERE comm IS NOT NULL AND comm <> 0;

-- 12. Names starting or ending with S
SELECT ename FROM emp WHERE ename LIKE 'S%' OR ename LIKE '%S';

-- 13. Names with I as the second character
SELECT ename FROM emp WHERE ename LIKE '_I%';

-- 14. Number of employees
SELECT COUNT(*) AS number_of_employees FROM emp;

-- 15. Number of distinct designations
SELECT COUNT(DISTINCT job) AS number_of_designations FROM emp;

-- 16. Total salary
SELECT SUM(sal) AS total_salary FROM emp;

-- 17. Maximum, minimum, and average salary
SELECT MAX(sal) AS maximum_salary, MIN(sal) AS minimum_salary, AVG(sal) AS average_salary FROM emp;

-- 18. Maximum salesman salary
SELECT MAX(sal) AS maximum_salesman_salary FROM emp WHERE job = 'SALESMAN';
