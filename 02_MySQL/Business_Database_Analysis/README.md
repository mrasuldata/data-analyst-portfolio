# MySQL Business Database Analysis

## Objective

Demonstrate practical SQL used by a data analyst: filtering, aggregation, joins, subqueries, CTEs, window functions, data-quality checks, and transaction awareness.

## Reproducible projects

### EMP/DEPT analysis

1. Run `queries/emp_dept_setup.sql` to create and populate the educational schema.
2. Run `queries/emp_dept_analysis.sql` for 18 business questions.
3. Optionally use `notebooks/Emp_Dept_SQL_Analysis.ipynb` to compare SQL results with pandas.

### Shop analysis

- `queries/shop_schema_and_queries.sql` builds a small shop schema and demonstrates foundational queries.
- `queries/advanced_analysis.sql` adds CTEs, window functions, Pareto-style contribution, running totals, data-quality checks, transactions, indexes, and `EXPLAIN ANALYZE`.

## Secure configuration

Copy the repository root `.env.example` to `.env` and set `PIIT_DATABASE_URL`. The real `.env` file is ignored by Git.

## Analyst limitations

The shop schema stores current product price rather than historical order-line price, so its spend calculations are educational models rather than production revenue accounting.
