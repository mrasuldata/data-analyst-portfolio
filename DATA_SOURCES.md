# Data sources and context

## Superstore — Python

The repository contains a validated, processed Sample Superstore-style CSV used for portfolio analysis. The original raw workbook is not included, so the notebook documents this limitation and validates the supplied analytical table rather than claiming to rebuild it from raw source files.

## Superstore — Tableau

The packaged Superstore 360 workbook contains an embedded Hyper extract. Its original connection metadata references two educational source files: Sample Superstore and Global Superstore. Those source files are not included. The Tableau project is therefore presented as a separate dashboard-design artifact rather than a reconciled front end for the Python analysis.

## MTCars

The project uses the public `mtcars` dataset distributed with R's `datasets` package. The local CSV is included so the notebook does not depend on an internet connection.

Source reference: https://stat.ethz.ch/R-manual/R-devel/library/datasets/html/mtcars.html

## MySQL

The `emp` and `dept` examples use a classic educational employee/department schema recreated in `emp_dept_setup.sql`. The shop project is a coursework-style schema included for SQL practice.

## Tableau Bookshop

The packaged workbook contains its own Tableau Hyper extract. The exact original external dataset source was not documented in the source repository, so the project is described as a coursework/portfolio dashboard rather than an independently sourced production dataset.

## Tableau UK Bank Customers

The packaged workbook contains an embedded Hyper extract from an educational UK bank customer dataset. The original CSV source is not included, and the data should not be represented as real customer banking information.

## Spreadsheet projects

Dealmakers and Scholar Insights are educational portfolio datasets. The cleaned workbooks document the calculations and corrections applied to the supplied source files.
