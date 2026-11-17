# Project notes and interpretation

## Dataset

Three related tables comprise the bookstore example: `books`, `customers`, and `orders`.
Each CSV contains 500 records. `orders.book_id` references `books.book_id` and
`orders.customer_id` references `customers.customer_id`.

## Verified checks from CSV files

| Test | Result |
| --- | ---: |
| Book rows | 500 |
| Customer rows | 500 |
| Order rows | 500 |
| Orphan order book references | 0 |
| Orphan order customer references | 0 |
| Recorded sales total (USD) | $75,628.66 |
| Quantity of books in orders | 2,697 |
| Sum of supplied `books.stock` | 25,056 |
| Price × quantity mismatches | 0 |
| Negative hypothetical post-order balances | 30 |

These figures were independently calculated from the supplied CSVs, not from a
live PostgreSQL execution. Run `sql/06_data_quality_checks.sql` in PostgreSQL to
repeat some of the checks.

## Query design decisions

- Distinguish `COUNT(order_id)` (number of orders) from `SUM(quantity)` (units).
- Group high-spending customers by `customer_id`, not just customer name.
- Query Q7 in the advanced section asks for **cities**, so the refined query
  returns cities without retaining a transaction amount per distinct row.
- For question "most frequently ordered book", the refined answer returns one
  book. The original code selected the seven most frequent; that is preserved
  as an exploratory query.
- The original script uses absolute Windows file paths with `COPY`, which are
  machine-specific. The new `psql` script uses relative client-side `\copy`.
- `PERCENTILE_CONT` is used for median price, a PostgreSQL ordered-set aggregate.

## Inventory interpretation caution

The question about stock "remaining after fulfilling all orders" requires the
supplied stock numbers to represent inventory **before** the historical orders.
The CSV does not establish this assumption. If each order is subtracted, 30
books have negative results. Therefore, this is documented as a hypothetical
inventory calculation, not verified operational stock.

## Public repository data notice

The customer CSV contains names, emails, and phone numbers. The dataset appears
exercise-oriented, but its provenance and redistribution rights have **not**
been independently verified. Review/replace/remove personal fields and confirm
permission to publish both the CSVs and assignment PDF before making a public
GitHub repository. The repository is packaged with the supplied data for local
reproducibility; you can remove `data/customers.csv` from a public version.
