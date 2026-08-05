from __future__ import annotations

import pandas as pd
import pytest

from superstore import (
    DataValidationError,
    compute_kpis,
    merge_orders_returns,
    normalize_postal_codes,
    prepare_returns,
)


def sample_orders() -> pd.DataFrame:
    return pd.DataFrame(
        {
            "Row ID": [1, 2, 3],
            "Order ID": ["A", "A", "B"],
            "Order Date": ["2024-01-01", "2024-01-01", "2024-02-01"],
            "Ship Date": ["2024-01-03", "2024-01-03", "2024-02-02"],
            "Postal Code": [1234, 1234, None],
            "Sales": [100.0, 50.0, 200.0],
            "Quantity": [1, 2, 1],
            "Profit": [10.0, -5.0, 40.0],
        }
    )


def test_duplicate_return_rows_do_not_multiply_line_items() -> None:
    returns = pd.DataFrame({"Order ID": ["A", "A"], "Returned": ["Yes", "Yes"]})
    merged = merge_orders_returns(sample_orders(), returns)

    assert len(merged) == 3
    assert merged.loc[merged["Order ID"].eq("A"), "Is Returned"].all()
    assert not merged.loc[merged["Order ID"].eq("B"), "Is Returned"].any()


def test_conflicting_return_flags_fail_fast() -> None:
    returns = pd.DataFrame({"Order ID": ["A", "A"], "Returned": ["Yes", "No"]})
    with pytest.raises(DataValidationError, match="Conflicting return flags"):
        prepare_returns(returns)


def test_kpis_use_unique_order_denominator() -> None:
    returns = pd.DataFrame({"Order ID": ["A"], "Returned": ["Yes"]})
    metrics = compute_kpis(merge_orders_returns(sample_orders(), returns))

    assert metrics["line_item_count"] == 3
    assert metrics["order_count"] == 2
    assert metrics["returned_order_count"] == 1
    assert metrics["return_rate"] == pytest.approx(0.5)
    assert metrics["sales"] == pytest.approx(350.0)
    assert metrics["average_order_value"] == pytest.approx(175.0)


def test_postal_codes_preserve_nulls_and_leading_zeroes() -> None:
    actual = normalize_postal_codes(pd.Series([1234, 90210, None]))
    assert actual.tolist() == ["01234", "90210", pd.NA]


def test_negative_shipping_duration_is_rejected() -> None:
    orders = sample_orders()
    orders.loc[0, "Ship Date"] = "2023-12-31"
    with pytest.raises(DataValidationError, match="before Order Date"):
        merge_orders_returns(orders, pd.DataFrame({"Order ID": [], "Returned": []}))
