"""Validated, reusable transformations for the Sample Superstore project."""

from __future__ import annotations

from pathlib import Path
from typing import Any

import pandas as pd

ORDER_COLUMNS = {
    "Row ID",
    "Order ID",
    "Order Date",
    "Ship Date",
    "Postal Code",
    "Sales",
    "Quantity",
    "Profit",
}
RETURN_COLUMNS = {"Order ID", "Returned"}


class DataValidationError(ValueError):
    """Raised when source data violates an expected analytical contract."""


def _require_columns(frame: pd.DataFrame, required: set[str], name: str) -> None:
    missing = sorted(required.difference(frame.columns))
    if missing:
        raise DataValidationError(f"{name} is missing required columns: {', '.join(missing)}")


def normalize_postal_codes(values: pd.Series) -> pd.Series:
    """Return nullable five-character postal codes without converting nulls to text."""
    numeric = pd.to_numeric(values, errors="coerce").astype("Int64")
    return numeric.astype("string").str.zfill(5)


def prepare_orders(orders: pd.DataFrame) -> pd.DataFrame:
    """Validate and clean line-item-level orders."""
    _require_columns(orders, ORDER_COLUMNS, "orders")
    clean = orders.copy()

    if clean["Row ID"].duplicated().any():
        examples = clean.loc[clean["Row ID"].duplicated(keep=False), "Row ID"].head().tolist()
        raise DataValidationError(f"Row ID must be unique; duplicate examples: {examples}")

    for column in ("Order Date", "Ship Date"):
        clean[column] = pd.to_datetime(clean[column], errors="raise")

    clean["Days to Ship"] = (clean["Ship Date"] - clean["Order Date"]).dt.days
    if clean["Days to Ship"].lt(0).any():
        raise DataValidationError("Ship Date occurs before Order Date for at least one line item")

    clean["Postal Code"] = normalize_postal_codes(clean["Postal Code"])

    for column in ("Sales", "Quantity", "Profit"):
        clean[column] = pd.to_numeric(clean[column], errors="raise")

    return clean


def prepare_returns(returns: pd.DataFrame) -> pd.DataFrame:
    """Reduce order-level return records to one unambiguous row per Order ID."""
    _require_columns(returns, RETURN_COLUMNS, "returns")
    clean = returns.loc[:, ["Order ID", "Returned"]].copy()
    clean["Order ID"] = clean["Order ID"].astype("string").str.strip()
    clean["Returned"] = clean["Returned"].astype("string").str.strip().str.title()
    clean = clean.dropna(subset=["Order ID"])

    invalid = sorted(set(clean["Returned"].dropna()) - {"Yes", "No"})
    if invalid:
        raise DataValidationError(f"Unexpected return flags: {invalid}")

    conflicts = clean.groupby("Order ID", dropna=False)["Returned"].nunique(dropna=True)
    conflicting_ids = conflicts[conflicts > 1].index.tolist()
    if conflicting_ids:
        raise DataValidationError(
            "Conflicting return flags for Order ID values: " + ", ".join(map(str, conflicting_ids[:5]))
        )

    # Duplicate 'Yes' rows carry no extra information and must not multiply order lines.
    return clean.drop_duplicates(subset=["Order ID"], keep="first").reset_index(drop=True)


def merge_orders_returns(orders: pd.DataFrame, returns: pd.DataFrame) -> pd.DataFrame:
    """Attach an order-level return flag to line items while preserving line-item grain."""
    clean_orders = prepare_orders(orders)
    clean_returns = prepare_returns(returns)
    original_rows = len(clean_orders)

    merged = clean_orders.merge(
        clean_returns,
        on="Order ID",
        how="left",
        validate="many_to_one",
        indicator=True,
    )
    if len(merged) != original_rows:
        raise DataValidationError(
            f"Merge changed row count from {original_rows:,} to {len(merged):,}; KPI grain is unsafe"
        )

    merged["Returned"] = merged["Returned"].fillna("No")
    merged["Is Returned"] = merged["Returned"].eq("Yes")
    return merged.drop(columns="_merge")


def compute_kpis(data: pd.DataFrame) -> dict[str, Any]:
    """Compute portfolio KPIs with explicit line-item and order-level denominators."""
    required = {"Order ID", "Sales", "Profit", "Quantity", "Is Returned"}
    _require_columns(data, required, "merged superstore data")

    order_flags = data.groupby("Order ID", dropna=False)["Is Returned"].max()
    order_count = int(order_flags.size)
    returned_order_count = int(order_flags.sum())
    sales = float(data["Sales"].sum())
    profit = float(data["Profit"].sum())

    return {
        "line_item_count": int(len(data)),
        "order_count": order_count,
        "returned_order_count": returned_order_count,
        "return_rate": returned_order_count / order_count if order_count else 0.0,
        "sales": sales,
        "profit": profit,
        "profit_margin": profit / sales if sales else 0.0,
        "quantity": float(data["Quantity"].sum()),
        "average_order_value": sales / order_count if order_count else 0.0,
    }


def export_tableau_data(data: pd.DataFrame, destination: str | Path) -> Path:
    """Write a clean, portable CSV after all return flags and validation are complete."""
    output = Path(destination)
    output.parent.mkdir(parents=True, exist_ok=True)
    data.to_csv(output, index=False)
    return output
