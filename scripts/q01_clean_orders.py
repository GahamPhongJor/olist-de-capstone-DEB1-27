"""
Q1. Clean messy order records
You receive raw order records from an upstream system. Return the clean rows:
  - strip spaces from order_id and status, and lowercase status
  - drop rows with no order_id
  - convert price to float; drop rows where that fails
Keep the original order of rows.
"""
from typing import Any


def clean_orders(orders: list[dict[str, Any]]) -> list[dict[str, Any]]:
    # TODO: your code here
    pass


orders = [
    {"order_id": " A1 ", "status": "DELIVERED", "price": "58.90"},
    {"order_id": None,   "status": "shipped",   "price": "10"},
    {"order_id": "A3",   "status": " Canceled", "price": "abc"},
]

if __name__ == "__main__":
    assert clean_orders(orders) == [{"order_id": "A1", "status": "delivered", "price": 58.9}]
    assert clean_orders([]) == []
    assert clean_orders([{"order_id": "   ", "status": "x", "price": "1"}]) == []
    assert clean_orders([{"order_id": "B1", "status": "Shipped", "price": 10}]) == [
        {"order_id": "B1", "status": "shipped", "price": 10.0}]
    print("All tests passed")
