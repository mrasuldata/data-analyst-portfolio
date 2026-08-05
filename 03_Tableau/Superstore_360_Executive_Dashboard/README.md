# Superstore 360 Executive Dashboard

A packaged Tableau workbook focused on executive sales and profitability analysis across customers, products, geography, shipping, discounting, and time.

## Portfolio artifact

- **Workbook:** [`workbook/Superstore_360_Executive_Dashboard.twbx`](workbook/Superstore_360_Executive_Dashboard.twbx)
- **Format:** Tableau packaged workbook with an embedded Hyper extract
- **Dashboards:** 7
- **Worksheets:** 30
- **Calculated fields and parameters:** includes Pareto analysis, average order value, profit ratio, customer order counts, shipping duration, top-N controls, and time-based calculations

## Dashboard areas

1. Sales Analysis
2. Profitability & Discount
3. Product Performance Insights
4. Customer Analysis
5. Geographic Performance Analysis
6. Shipping & Delivery
7. Time Series & Trend

## Analyst use cases

- Compare sales and profit performance across products, categories, customers, regions, and time.
- Examine the relationship between discounting and profitability.
- Identify high-value customers and repeat-purchase patterns.
- Review delivery and shipping performance.
- Explore product and customer concentration using Pareto-style views.

## Important scope notes

- The workbook is a separate Tableau project and should **not** be presented as a direct visualization of the Python Superstore dataset.
- The packaged extract references two educational Superstore source files in its original connection metadata. The original source files are not included, so the workbook can be viewed from the packaged extract but cannot be refreshed from those files.
- The workbook does not contain a verified Returns field; do not describe it as a returns-analysis dashboard.
- Package integrity and embedded-extract presence were checked automatically. Visual rendering, filters, and exact calculated values should be reviewed once in Tableau Desktop or Tableau Public before quoting specific figures.
