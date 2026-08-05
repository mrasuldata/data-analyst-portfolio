# Data Analyst Portfolio

Selected projects demonstrating how I use **SQL, spreadsheets, Tableau, and Python** to clean and validate data, define reliable metrics, identify business patterns, and communicate findings.

## Core skills

- **SQL and MySQL:** filtering, joins, aggregation, subqueries, common table expressions, window functions, data-quality checks, and transactions
- **Spreadsheets:** lookup formulas, conditional formatting, structured summaries, target analysis, data-quality review, and chart-based reporting
- **Tableau:** packaged dashboards, calculated fields, filters, KPI reporting, segmentation, and visual storytelling
- **Python:** pandas-based cleaning, exploratory analysis, visualization, metric validation, and reproducible notebooks

## Featured projects

| Area | Project | Analyst focus |
|---|---|---|
| Python | [Superstore Business Performance](01_Python/Superstore_Business_Performance/README.md) | Sales, profitability, returns, shipping, customer behavior, KPI definitions, and join-grain validation |
| Tableau | [Superstore 360 Executive Dashboard](03_Tableau/Superstore_360_Executive_Dashboard/README.md) | Executive sales, profit, product, customer, geographic, discount, shipping, and time analysis |
| MySQL | [Business Database Analysis](02_MySQL/Business_Database_Analysis/README.md) | Reproducible schemas, business queries, joins, CTEs, window functions, and query-quality checks |
| Tableau | [Bookshop Visual Storytelling Dashboard](03_Tableau/Bookshop_Visual_Storytelling_Dashboard/README.md) | Packaged dashboard design, pricing, sales, ratings, seasonal analysis, and visual storytelling |
| Tableau | [UK Bank Customers Dashboard](03_Tableau/UK_Bank_Customers_Dashboard/README.md) | Customer segmentation by age, balance, gender, job classification, and region |
| Google Sheets | [Scholar Insights Engine](04_Google_Sheets/Scholar_Insights_Engine/README.md) | Student performance, class targets, pass rates, formula-driven summaries, and charts |
| Google Sheets | [Dealmakers Deep Dive](04_Google_Sheets/Dealmakers_Deep_Dive/README.md) | Revenue analysis by salesperson, region, product, and category with duplicate control |
| Python | [MTCars Exploratory Analysis](01_Python/MTCars_Exploratory_Analysis/README.md) | Descriptive statistics, correlation, visualization, and careful non-causal interpretation |

## Suggested exploration order

1. Superstore Business Performance — Python
2. Superstore 360 Executive Dashboard — Tableau
3. Business Database Analysis — MySQL
4. Bookshop Visual Storytelling Dashboard — Tableau
5. Scholar Insights Engine — Google Sheets
6. Dealmakers Deep Dive — Google Sheets
7. UK Bank Customers Dashboard — Tableau
8. MTCars Exploratory Analysis — Python

## Quality and scope notes

- Superstore returns are measured at **order level**, while the Python analytical table remains at **order-line level**.
- The Python Superstore project and Tableau Superstore project use different supplied artifacts and should not be claimed as directly reconciled versions of the same data pipeline.
- Spreadsheet target comparisons use both **class and subject**, avoiding ambiguous lookups.
- MTCars findings are presented as descriptive associations from a small observational dataset, not causal proof.
- Tableau workbooks are packaged with embedded extracts. Original external source files are not included, so viewing is portable but source refresh may require reconnection.

## Running the Python projects

```bash
python -m pip install -r requirements.txt
python -m pytest 01_Python/Superstore_Business_Performance/tests -v
```

See [DATA_SOURCES.md](DATA_SOURCES.md) for source and limitation notes.
