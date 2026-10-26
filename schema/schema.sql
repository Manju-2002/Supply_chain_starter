
CREATE TABLE sku (
  sku_id VARCHAR(20) PRIMARY KEY,
  sku_name VARCHAR(100) NOT NULL,
  uom VARCHAR(10) NOT NULL,
  unit_cost DECIMAL(12,2) NOT NULL CHECK (unit_cost >= 0),
  status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE','INACTIVE'))
);

CREATE TABLE location (
  location_id VARCHAR(20) PRIMARY KEY,
  location_name VARCHAR(100) NOT NULL,
  country VARCHAR(3) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE','INACTIVE'))
);

CREATE TABLE forecast_demand (
  demand_id VARCHAR(100) PRIMARY KEY,
  sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  location_id VARCHAR(20) NOT NULL REFERENCES location(location_id),
  week_start DATE NOT NULL,
  forecast_qty INTEGER NOT NULL CHECK (forecast_qty >= 0),
  UNIQUE(sku_id, location_id, week_start)
);

CREATE TABLE inventory (
  inventory_id VARCHAR(30) PRIMARY KEY,
  sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  location_id VARCHAR(20) NOT NULL REFERENCES location(location_id),
  on_hand_qty INTEGER NOT NULL CHECK (on_hand_qty >= 0),
  safety_stock_qty INTEGER NOT NULL CHECK (safety_stock_qty >= 0),
  UNIQUE(sku_id, location_id)
);

CREATE TABLE supplier (
  supplier_id VARCHAR(20) PRIMARY KEY,
  supplier_name VARCHAR(100) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('ACTIVE','INACTIVE')),
  reliability_pct DECIMAL(5,2) CHECK (reliability_pct BETWEEN 0 AND 100)
);

CREATE TABLE supplier_capacity (
  capacity_id VARCHAR(30) PRIMARY KEY,
  supplier_id VARCHAR(20) NOT NULL REFERENCES supplier(supplier_id),
  week_start DATE NOT NULL,
  capacity_qty INTEGER NOT NULL CHECK (capacity_qty >= 0),
  minimum_order_qty INTEGER NOT NULL CHECK (minimum_order_qty >= 0),
  UNIQUE(supplier_id, week_start)
);

CREATE TABLE lead_time (
  lead_time_id VARCHAR(30) PRIMARY KEY,
  supplier_id VARCHAR(20) NOT NULL REFERENCES supplier(supplier_id),
  location_id VARCHAR(20) NOT NULL REFERENCES location(location_id),
  lead_time_days INTEGER NOT NULL CHECK (lead_time_days >= 0),
  effective_from DATE NOT NULL,
  effective_to DATE NOT NULL,
  CHECK (effective_to >= effective_from),
  UNIQUE(supplier_id, location_id, effective_from)
);

CREATE TABLE purchase_order (
  po_id VARCHAR(30) PRIMARY KEY,
  supplier_id VARCHAR(20) NOT NULL REFERENCES supplier(supplier_id),
  sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  location_id VARCHAR(20) NOT NULL REFERENCES location(location_id),
  order_week DATE NOT NULL,
  ordered_qty INTEGER NOT NULL CHECK (ordered_qty > 0),
  lead_time_days INTEGER NOT NULL CHECK (lead_time_days >= 0),
  expected_receipt_date DATE NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('OPEN','RECEIVED','IN_TRANSIT','CANCELLED')),
  inbound_qty INTEGER NOT NULL CHECK (inbound_qty >= 0),
  transport_delay_days INTEGER NOT NULL CHECK (transport_delay_days >= 0),
  actual_receipt_date DATE
);

CREATE TABLE production_plan (
  production_plan_id VARCHAR(30) PRIMARY KEY,
  sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  location_id VARCHAR(20) NOT NULL REFERENCES location(location_id),
  week_start DATE NOT NULL,
  planned_qty INTEGER NOT NULL CHECK (planned_qty >= 0),
  production_capacity_qty INTEGER NOT NULL CHECK (production_capacity_qty >= planned_qty)
);

CREATE TABLE bom (
  bom_id VARCHAR(30) PRIMARY KEY,
  parent_sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  component_sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  component_qty INTEGER NOT NULL CHECK (component_qty > 0),
  UNIQUE(parent_sku_id, component_sku_id)
);

CREATE TABLE substitute (
  substitute_id VARCHAR(30) PRIMARY KEY,
  sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  substitute_sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  approved BOOLEAN NOT NULL,
  conversion_factor DECIMAL(12,4) NOT NULL CHECK (conversion_factor > 0),
  CHECK (sku_id <> substitute_sku_id)
);

CREATE TABLE shortage (
  shortage_id VARCHAR(30) PRIMARY KEY,
  sku_id VARCHAR(20) NOT NULL REFERENCES sku(sku_id),
  location_id VARCHAR(20) NOT NULL REFERENCES location(location_id),
  week_start DATE NOT NULL,
  shortage_qty INTEGER NOT NULL CHECK (shortage_qty > 0),
  shortage_cause VARCHAR(50) NOT NULL,
  status VARCHAR(20) NOT NULL CHECK (status IN ('OPEN','MITIGATED','CLOSED'))
);

CREATE TABLE mitigation_option (
  mitigation_id VARCHAR(60) PRIMARY KEY,
  shortage_id VARCHAR(30) NOT NULL REFERENCES shortage(shortage_id),
  option_type VARCHAR(50) NOT NULL,
  estimated_cost_pct DECIMAL(8,4) NOT NULL,
  service_lead_time_days INTEGER NOT NULL,
  feasible BOOLEAN NOT NULL,
  decision_score DECIMAL(12,2) NOT NULL
);
