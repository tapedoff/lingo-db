# Biomed starter dataset (synthetic)

This folder provides a minimal synthetic biomedical schema for trying LingoDB with heterogeneous clinical and omics-like data.

## Files

- `initialize.sql`: creates and populates 6 core tables.
- `starter_queries.sql`: 5 starter analytics queries.

## Quick start

```bash
./build/lingodb-debug/sql /tmp/biomed-db < resources/sql/biomed/initialize.sql
./build/lingodb-debug/sql /tmp/biomed-db < resources/sql/biomed/starter_queries.sql
```

> Notes:
> - Data is synthetic and for demonstration only.
> - Adjust date/time or scalar functions in `starter_queries.sql` to match your build/runtime SQL compatibility if needed.
