-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS db_ecommerce;

-- CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers(
  -- user_id UUID DEFAULT uuid_generate_v4() PRIMARY KEY
  customer_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  document_type VARCHAR(10) NOT NULL,
  document_number VARCHAR(20),
  is_company BOOLEAN DEFAULT FALSE,
  tax_regime VARCHAR(30),
  registration_date TIMESTAMP DEFAULT NOW(),
  loyalty_points INTGEGER DEFAULT 0,
  total_orders INTEGER DEFAULT 0,
  total_spent DECIMAL(12,2) DEFAULT 0,
  is_vip BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- DEPARTMENTS TABLE
CREATE TABLE IF NOT EXISTS departments(
  department_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  department_name VARCHAR(100) NOT NULL,
  budget DECIMAL(15,2),
  spent_amount DECIMAL(15,2) DEFAULT 0,
  manager_id INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- CATEGORIES TABLE
CREATE TABLE IF NOT EXISTS categories (
  category_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  category_name VARCHAR(100) NOT NULL,
  parent_id INTEGER,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_parent_category
    FOREIGN KEY (parent_id)
    REFERENCES categories(category_id)
    ON DELETE SET NULL
);

-- ALTER TABLE categories ADD CONSTRAINT fk_parent_category
--   FOREIGN KEY(parent_id) REFERENCES categories(category_id)
--     ON DELETE SET NULL;

-- ADDRESSES TABLE
CREATE TABLE IF NOT EXISTS addresses (
  address_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  customer_id BIGINT,
  address_type VARCHAR(50),
  street VARCHAR(100) NOT NULL,
  neighborhood VARCHAR(100),
  city VARCHAR(100),
  department VARCHAR(100),
  postal_code VARCHAR(20),
  country VARCHAR(100),
  address_reference TEXT,
  latitude DECIMAL(10,8),
  logitude DECIMAL(11, 8),
  is_default BOOLEAN DEFAULT FALSE,
  createt_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT ck_addres_type
    CHECK (address_type IN ('', '', '')), --TODO
  CONSTRAINT fk_address_customer
    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
);

-- 🔵 6: PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS products(
  product_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  sku VARCHAR(100) NOT NULL,
  product_name VARCHAR(100) NOT NULL,
  description TEXT,
  category_id INT,
  base_price DECIMAL(11,2) NOT NULL,
  discount_price DECIMAL(11,2) NOT NULL,
  cost DECIMAL(12, 2),
  weight DECIMAL(8,3),
  length DECIMAL(8,3),
  width DECIMAL(8,3),
  height DECIMAL(8,3),
  stock_quantity INTEGER DEFAULT 0,
  reorder_level INTEGER DEFAULT 10,
  unit_sold INTEGER DEFAULT 0,
  rating_average DECIMAL(3,2) DEFAULT 0,
  rating_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_product_category
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
    ON DELETE SET NULL
);

-- REFERENCES departments -> employees TODO: ADD REFERENCE



