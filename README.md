# Supply Chain Planning Synthetic Dataset

## Purpose
Synthetic end-to-end workflow for matching forecast demand to inventory, supplier capacity, lead times and production constraints, then identifying shortages and candidate mitigations.

## Reproducibility
Seed: `20261022`

Example:
`python generator/generator.py --output data`

Starter dataset:
`python generator/generator.py --output data --skus 100 --locations 5 --suppliers 20 --weeks 12 --inbound-orders 300`

Full dataset:
`python generator/generator.py --output data --skus 3000 --locations 50 --suppliers 500 --weeks 52 --inbound-orders 10000`

## Outputs
CSV files for master, transaction, derived and bridge entities; `ground_truth.csv`; `validation_summary.json`.

## Important design rules
- Parent/master records are generated before dependent records.
- IDs are deterministic and immutable.
- Derived balances are calculated from source demand, inventory, inbound and production.
- Ground truth is separate from model/input data.
- Historical state is represented as explicit records rather than overwritten history.
- Synthetic data is used; no personal/confidential information is required.

## Edge cases
1. Inbound counted twice
2. Substitute not approved
3. Supplier capacity exceeded
4. Shortage calculated without lead time
5. Units-of-measure mismatch

## Suggested evaluation metrics
- Forecast-to-supply reconciliation rate
- Shortage detection precision/recall against ground truth
- Capacity violation detection rate
- Invalid mitigation rejection rate
- Projected balance reconciliation error
- On-time mitigation/service recovery rate
- Total mitigation cost
- Reproducibility checksum match
