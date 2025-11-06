DROP DATABASE IF EXISTS sampledb;
CREATE DATABASE sampledb;

-- \connect sampledb

-- SET datestyle TO 'DMY';

DROP TABLE IF EXISTS fact_table;
DROP TABLE IF EXISTS payment_dim;
DROP TABLE IF EXISTS customer_dim;
DROP TABLE IF EXISTS item_dim;
DROP TABLE IF EXISTS store_dim;
DROP TABLE IF EXISTS time_dim;

CREATE TABLE payment_dim (
    payment_key TEXT PRIMARY KEY,
    trans_type  TEXT,
    bank_name   TEXT
);

CREATE TABLE customer_dim (
    customer_key TEXT PRIMARY KEY,
    name         TEXT,
    contact_no   TEXT,
    nid          TEXT
);

CREATE TABLE item_dim (
    item_key    TEXT PRIMARY KEY,
    item_name   TEXT,
    description TEXT,
    unit_price  NUMERIC(10,2),
    man_country TEXT,
    supplier    TEXT,
    unit        TEXT
);

CREATE TABLE store_dim (
    store_key TEXT PRIMARY KEY,
    division  TEXT,
    district  TEXT,
    upazila   TEXT
);

CREATE TABLE time_dim (
    time_key TEXT PRIMARY KEY,
    date TIMESTAMP,
    hour INTEGER,
    day INTEGER,
    week TEXT,
    month INTEGER,
    quarter TEXT,
    year INTEGER
);


CREATE TABLE fact_table (
    payment_key TEXT,
    customer_key TEXT,
    time_key TEXT,
    item_key TEXT,
    store_key TEXT,
    quantity INTEGER,
    unit TEXT,
    unit_price NUMERIC(10,2),
    total_price NUMERIC(10,2),
    FOREIGN KEY (payment_key) REFERENCES payment_dim(payment_key),
    FOREIGN KEY (customer_key) REFERENCES customer_dim(customer_key),
    FOREIGN KEY (time_key) REFERENCES time_dim(time_key),
    FOREIGN KEY (item_key) REFERENCES item_dim(item_key),
    FOREIGN KEY (store_key) REFERENCES store_dim(store_key)
);

