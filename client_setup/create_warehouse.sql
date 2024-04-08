-- creates standardized warehouses for new client environments

-- Creates x-small warehouse
    CREATE OR REPLACE WAREHOUSE WH_XSM 
    WAREHOUSE_SIZE = 'XSMALL'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    SCALING_POLICY = 'STANDARD'
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 3
    INITIALLY_SUSPENDED = TRUE;

-- Creates medium warehouse
    CREATE OR REPLACE WAREHOUSE WH_MD
    WAREHOUSE_SIZE = 'MEDIUM'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    SCALING_POLICY = 'STANDARD'
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 5
    INITIALLY_SUSPENDED = TRUE;

-- Creates  x-large warehouse
    CREATE OR REPLACE WAREHOUSE WH_XLG
    WAREHOUSE_SIZE = 'XLARGE'
    WAREHOUSE_TYPE = 'STANDARD'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    SCALING_POLICY = 'STANDARD'
    MIN_CLUSTER_COUNT = 1
    MAX_CLUSTER_COUNT = 8
    INITIALLY_SUSPENDED = TRUE;