#!/usr/bin/env python3
"""Validate input file structure, keys, and recorded line totals; standard library only."""
import csv
from collections import Counter
from decimal import Decimal
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / 'data'
SCHEMAS = {
    'books': ['Book_ID', 'Title', 'Author', 'Genre', 'Published_Year', 'Price', 'Stock'],
    'customers': ['Customer_ID', 'Name', 'Email', 'Phone', 'City', 'Country'],
    'orders': ['Order_ID', 'Customer_ID', 'Book_ID', 'Order_Date', 'Quantity', 'Total_Amount'],
}

def load(name):
    with (ROOT / f'{name}.csv').open(encoding='utf-8-sig', newline='') as f:
        reader = csv.DictReader(f)
        assert reader.fieldnames == SCHEMAS[name], f'{name}: unexpected columns'
        rows = list(reader)
    assert all(all(value.strip() for value in row.values()) for row in rows), f'{name}: empty values'
    key = {'books': 'Book_ID', 'customers': 'Customer_ID', 'orders': 'Order_ID'}[name]
    assert len({row[key] for row in rows}) == len(rows), f'{name}: duplicate primary key'
    print(f'{name}: {len(rows)} rows, columns OK, no empty cells or duplicate primary keys')
    return rows

def main():
    books, customers, orders = [load(n) for n in SCHEMAS]
    by_book = {r['Book_ID']: r for r in books}
    ids_customers = {r['Customer_ID'] for r in customers}
    assert all(o['Book_ID'] in by_book and o['Customer_ID'] in ids_customers for o in orders), 'invalid foreign keys'
    assert all(Decimal(o['Total_Amount']) == Decimal(by_book[o['Book_ID']]['Price']) * int(o['Quantity']) for o in orders), 'order totals do not match price * quantity'
    units = Counter()
    for o in orders: units[o['Book_ID']] += int(o['Quantity'])
    negative = sum(int(b['Stock']) - units[b['Book_ID']] < 0 for b in books)
    revenue = sum((Decimal(o['Total_Amount']) for o in orders), Decimal('0'))
    print(f'foreign keys: OK | order line totals: OK | revenue: ${revenue:,.2f}')
    print(f'books with negative hypothetical post-order stock: {negative} (see README caveat)')
    print('CSV validation passed.')

if __name__ == '__main__': main()
