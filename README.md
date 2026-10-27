# Supply Chain Planning – Synthetic Dataset & Dashboard

## Overview

A synthetic end-to-end **Supply Chain Planning** solution for matching forecast demand with inventory, supplier capacity, lead times, purchase orders, and production constraints.

The project identifies potential shortages and provides candidate mitigation options through an interactive **Streamlit dashboard**.

## Key Features

- Forecast demand analysis
- Inventory and safety-stock monitoring
- Supplier capacity analysis
- Purchase order and inbound supply tracking
- Lead-time analysis
- Production plan analysis
- Shortage identification
- Shortage cause analysis
- Mitigation option analysis
- Interactive filtering by SKU and location
- CSV data download from the dashboard
- Synthetic ground-truth data for evaluation
- Dataset validation and reproducibility

## Technology Stack

- **Python 3.12**
- **Pandas**
- **NumPy**
- **Plotly**
- **Streamlit**
- **CSV / JSON**
- **Git / GitHub**

## Project Structure

```text
supply_chain_planning_starter/
│
├── app.py
├── README.md
├── requirements.txt
│
├── data/
│   ├── bom.csv
│   ├── forecast_demand.csv
│   ├── ground_truth.csv
│   ├── inventory.csv
│   ├── lead_time.csv
│   ├── location.csv
│   ├── mitigation_option.csv
│   ├── production_plan.csv
│   ├── purchase_order.csv
│   ├── shortage.csv
│   ├── sku.csv
│   ├── substitute.csv
│   ├── supplier.csv
│   ├── supplier_capacity.csv
│   └── validation_summary.json
│
├── generator/
│   └── generator.py
│
└── schema/
    ├── data_dictionary.csv
    └── schema.sql
```

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/Manju-2002/Supply_chain_starter.git
cd Supply_chain_starter
```

### 2. Install dependencies

Using Python 3.12:

```bash
python -m pip install -r requirements.txt
```

If required, install the dashboard packages separately:

```bash
python -m pip install streamlit plotly
```

## Generate the Dataset

### Starter Dataset

```bash
python generator/generator.py --output data --skus 100 --locations 5 --suppliers 20 --weeks 12 --inbound-orders 300
```

### Default Dataset

```bash
python generator/generator.py --output data
```

### Full Dataset

```bash
python generator/generator.py --output data --skus 3000 --locations 50 --suppliers 500 --weeks 52 --inbound-orders 10000
```

## Run the Dashboard

Start the Streamlit application:

```bash
python -m streamlit run app.py
```

The application will open in your browser.

Default local URL:

```text
http://localhost:8501
```

The dashboard provides:

- Demand overview
- Inventory overview
- Shortage analysis
- Supplier capacity analysis
- Weekly demand and shortage trends
- Shortage causes
- Mitigation options
- SKU and location filters
- Downloadable shortage data

## Reproducibility

Seed:

```text
20261022
```

The generator uses a fixed seed to make the synthetic dataset reproducible.

## Dataset Outputs

The generator produces CSV files for:

- SKU master data
- Locations
- Suppliers
- Supplier capacity
- Forecast demand
- Inventory
- Purchase orders
- Lead times
- Production plans
- BOM relationships
- Substitute products
- Shortages
- Mitigation options

It also produces:

- `ground_truth.csv`
- `validation_summary.json`

## Important Design Rules

- Parent/master records are generated before dependent records.
- IDs are deterministic and immutable.
- Derived balances are calculated from source demand, inventory, inbound supply, and production.
- Ground truth is kept separate from model/input data.
- Historical state is represented as explicit records rather than overwritten history.
- Synthetic data is used; no personal or confidential information is required.

## Edge Cases Covered

1. Inbound supply counted twice
2. Substitute product not approved
3. Supplier capacity exceeded
4. Shortage calculated without lead time
5. Unit-of-measure mismatch

## Validation

The generated dataset includes validation checks covering:

- Primary key validation
- Foreign key generation
- Derived balance calculations
- Ground-truth separation
- Fixed-seed reproducibility
- Null-value checks
- Duplicate-record checks

Validation results are stored in:

```text
data/validation_summary.json
```

## Suggested Evaluation Metrics

- Forecast-to-supply reconciliation rate
- Shortage detection precision and recall against ground truth
- Capacity violation detection rate
- Invalid mitigation rejection rate
- Projected balance reconciliation error
- On-time mitigation/service recovery rate
- Total mitigation cost
- Reproducibility checksum match

## Synthetic Data

All data in this project is synthetic and created for supply chain planning analysis and demonstration purposes.

No personal, confidential, or production business data is required.

## Author

**Manju-2002**

GitHub: https://github.com/Manju-2002
