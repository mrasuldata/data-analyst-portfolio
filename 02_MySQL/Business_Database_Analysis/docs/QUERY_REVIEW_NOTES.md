# Query review notes

- Employee filter question 4 includes all requested IDs: 7369, 7521, 7839, 7934, and 7788.
- Designation count uses `COUNT(DISTINCT job)` rather than counting employee rows.
- `NOT EXISTS` is used for null-safe anti-join logic in the advanced shop analysis.
- Window functions use deterministic tie ordering where row order matters.
- The transaction example ends with `ROLLBACK` so it does not permanently change salaries.
