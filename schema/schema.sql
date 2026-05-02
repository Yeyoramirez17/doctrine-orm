-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS db_ecommerce;

-- ENUMS
CREATE TYPE document_type AS ENUM('CC', 'CE', 'TI', 'NIT', 'PP');
CREATE TYPE address_type  AS ENUM('billing', 'ahipping');

-- DEPARTMENTS TABLE
CREATE TABLE IF NOT EXISTS departments(
  department_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  department_name VARCHAR(100) NOT NULL,
  budget DECIMAL(15,2) DEFAULT 0,
  spent_amount DECIMAL(15,2) DEFAULT 0,
  manager_id INTEGER,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT ck_budget CHECK(budget >= 0),
  CONSTRAINT ck_spent_amount CHECK(spent_amount >= 0)
);

CREATE TABLE IF NOT EXISTS employees(
  employee_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  document_type document_type NOT NULL,
  document_number VARCHAR(20) NOT NULL,
  hire_date DATE NOT NULL,
  salary DECIMAL(10,2) NOT NULL DEFAULT 0,
  commission_pct DECIMAL(5,2) DEFAULT 0,
  department_id BIGINT NOT NULL,
  manager_employee_id BIGINT, -- default NULL
  is_employee_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT ck_salary_employee CHECK(salary >= 0)
);
-- employee -> department_id
ALTER TABLE employees ADD CONSTRAINT
  fk_employee_department FOREIGN KEY (department_id)
  REFERENCES departments(department_id)
  ON DELETE SET NULL;
-- department -> employee_id
ALTER TABLE departments ADD CONSTRAINT
  fk_department_manager FOREIGN KEY(manager_id)
  REFERENCES employees(employee_id);

-- CATEGORIES TABLE
CREATE TABLE IF NOT EXISTS categories (
  category_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  category_name VARCHAR(100) UNIQUE NOT NULL,
  category_slug VARCHAR(100) UNIQUE NOT NULL,
  parent_id BIGINT, -- category -> parent
  description TEXT,
  image_url VARCHAR(100),
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_parent_category
    FOREIGN KEY (parent_id)
    REFERENCES categories(category_id)
    ON DELETE SET NULL
);

-- CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS customers(
  customer_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  document_type document_type NOT NULL,
  document_number VARCHAR(20) NOT NULL,
  is_company BOOLEAN DEFAULT FALSE,
  tax_regime VARCHAR(50), -- Regimen Fiscal
  registration_date TIMESTAMP DEFAULT NOW(),
  loyalty_points INTGEGER DEFAULT 0 CHECK(loyalty_points >= 0), -- Puntos acumulados
  total_orders INTEGER DEFAULT 0 CHECK(total_orders >= 0),
  total_spent DECIMAL(12,2) DEFAULT 0 CHECK(total_spent >= 0),
  is_vip BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ADDRESSES TABLE
CREATE TABLE IF NOT EXISTS addresses (
  address_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  customer_id BIGINT NOT NULL,
  address_type address_type NOT NULL,
  street VARCHAR(100) NOT NULL,
  neighborhood VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  department VARCHAR(100) NOT NULL,
  postal_code VARCHAR(20),
  country VARCHAR(100) DEFAULT 'Colombia',
  address_reference TEXT,
  latitude DECIMAL(10,8),
  logitude DECIMAL(11, 8),
  is_default BOOLEAN DEFAULT FALSE,
  createt_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_address_customer
    FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
);

-- Warehouses
CREATE TABLE IF NOT EXISTS warehouses(

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



