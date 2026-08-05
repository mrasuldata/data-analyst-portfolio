# Data grain and metric contracts

## Superstore

| Dataset | Grain | Expected key | Important note |
|---|---|---|---|
| Orders | One product line within an order | `Row ID` | `Order ID` repeats when an order contains multiple products |
| Returns | One return flag per order after validation | `Order ID` | Duplicate source rows must be checked for conflicting flags, then reduced before joining |
| Corrected Tableau CSV | One product line within an order | `Row ID` | Return status is repeated across the order's line items; order-level rates must deduplicate `Order ID` |

### Metric contracts

- **Sales:** sum of line-item `Sales`.
- **Profit:** sum of line-item `Profit`.
- **Profit margin:** total profit divided by total sales; not the unweighted mean of row margins.
- **Order count:** distinct `Order ID`.
- **Line-item count:** row count or distinct `Row ID` after validation.
- **Returned order count:** distinct orders whose validated return flag is Yes.
- **Return rate:** returned order count divided by order count.
- **Average order value:** total sales divided by distinct order count.
- **Days to ship:** `Ship Date - Order Date`; this is elapsed processing/transport time, not on-time performance because no promised date is present.

## LevelUp Shop SQL schema

| Dataset | Grain | Key | Limitation |
|---|---|---|---|
| products | One product | `id` | Price is current catalog price |
| customers | One customer | `cust_id` | Minimal attributes |
| orders | One simplified order/product record | `order_id` | No quantity, order-line table, historical unit price, status, or amount |
| departments | One department | `dept_id` | Department deletion cascades to employees in the assignment schema |
| employees | One employee | `emp_id` | Simplified salary model |
| payments | One payment event | `pay_id` | No pay type or period field |

Any “spend” calculated by joining orders to current product price is a modeled educational value, not a historically accurate transaction amount.

## `mtcars`

- Grain: one car model/configuration per row.
- Sample size: 32.
- Outcome often analyzed: miles per gallon (`mpg`).
- Predictors are observational and interrelated; descriptive associations do not identify causal effects.
