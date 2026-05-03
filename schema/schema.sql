-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS db_ecommerce;

-- ENUMS
CREATE TYPE document_type AS ENUM('CC', 'CE', 'TI', 'NIT', 'PP');
CREATE TYPE address_type  AS ENUM('billing', 'ahipping');
CREATE TYPE payment_method AS ENUM('PSE', 'NEQUI', 'DAVIPLATA', 'CARD', 'CASH', 'BANK_TRANSFER');
CREATE TYPE order_status AS ENUM('pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled', 'returned');
CREATE TYPE payment_status AS ENUM('pending', 'approved', 'declined', 'refunded', 'chargeback');
CREATE TYPE shipment_status AS ENUM('pending', 'packed', 'in_transit', 'out_for_delivery', 'delivered', 'returned', 'failed_delivery');
CREATE TYPE invoice_status AS ENUM('draft', 'issued', 'validated', 'cancelled', 'rejected');


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
-- Employees table
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
-- employe -> manager
ALTER TABLE employees ADD CONSTRAINT
  fk_employee_manager FOREIGN KEY(manager_employee_id)
  REFERENCES employees(employee_id)
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
  loyalty_points INTEGER DEFAULT 0 CHECK(loyalty_points >= 0), -- Puntos acumulados
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

-- Warehouses table
CREATE TABLE IF NOT EXISTS warehouses(
  warehouse_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  warehouse_name VARCHAR(100) NOT NULL,
  warehouse_code VARCHAR(100) NOT NULL UNIQUE,
  address VARCHAR(200) NOT NULL,
  neighborhood VARCHAR(100),
  city VARCHAR(100) NOT NULL,
  department VARCHAR(100) NOT NULL,
  postal_code VARCHAR(10),
  phone VARCHAR(20),
  email VARCHAR(100),
  manager_employee_id BIGINT,
  is_warehouse_active BOOLEAN DEFAULT TRUE,
  warehouse_capacity_units INTEGER,
  warehouse_operating_hours VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT ck_warehouse_capacity CHECK(warehouse_capacity_units >= 0),
  CONSTRAINT fk_manager_employee_id FOREIGN KEY(manager_employee_id)
    REFERENCES employees(employee_id)
    ON DELETE SET NULL
);

-- PRODUCTS TABLE
CREATE TABLE IF NOT EXISTS products(
  product_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  product_sku VARCHAR(100) UNIQUE NOT NULL,
  product_barcode VARCHAR(100) UNIQUE,
  product_name VARCHAR(100) NOT NULL,
  description TEXT,
  short_description VARCHAR(500),
  category_id BIGINT,
  base_price DECIMAL(12,2) NOT NULL,
  discount_price DECIMAL(12,2) NOT NULL,
  product_cost DECIMAL(12, 2) NOT NULL ,
  product_iva_rate DECIMAL(5,2) NOT NULL DEFAULT 19.00,
  product_is_taxable BOOLEAN DEFAULT TRUE,
  product_weight DECIMAL(8,3),
  product_dimensions VARCHAR(100),
  stock_quantity INTEGER DEFAULT 0,         -- Stock
  product_units_sold INTEGER DEFAULT 0,     -- Cantidades vendidas
  product_reorder_level INTEGER DEFAULT 10, -- Stock minimo a recordar
  rating_average DECIMAL(3,2) DEFAULT 0,
  rating_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  is_featured BOOLEAN DEFAULT FALSE,
  product_images JSON,
  product_tags VARCHAR(500),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT ck_base_price_greater_than_zero CHECK(base_price > 0),
  CONSTRAINT ck_discount_price_greater_equal_zero CHECK(discount_price >= 0),
  CONSTRAINT ck_product_cost_greater_equal_zero CHECK(product_cost >= 0),
  CONSTRAINT ck_product_iva_rate_greater_equal_zero CHECK(product_iva_rate >= 0),
  CONSTRAINT ck_weight_greater_equal_zero CHECK(product_weight >= 0),
  CONSTRAINT ck_stock_quantity_greater_equal_zero CHECK(stock_quantity >= 0),
  CONSTRAINT ck_stock_product_units_sold_greater_equal_zero CHECK(product_units_sold >= 0),
  CONSTRAINT ck_rating_average_check CHECK(rating_average BETWEEN 1 AND 5),
  CONSTRAINT ck_rating_count_greater_equal_zero CHECK(rating_count >= 0),
  CONSTRAINT fk_product_category
    FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
    ON DELETE SET NULL
);
CREATE INDEX idx_product_sku ON products(product_sku);
CREATE INDEX idx_product_barcode ON products(product_barcode);
CREATE INDEX idx_product_active_and_feactured ON products(is_active, is_featured);

-- Inventory Table
CREATE TABLE IF NOT EXISTS inventory(
  inventory_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  product_id BIGINT NOT NULL,
  warehouse_id BIGINT NOT NULL,
  quantity_on_hand INTEGER NOT NULL CHECK(quantity_on_hand >= 0),
  quantity_reserved INTEGER NOT NULL CHECK(quantity_reserved >= 0),
  quantity_available INTEGER NOT NULL CHECK(quantity_available >= 0),
  reorder_point INTEGER DEFAULT 10 CHECK(reorder_point >= 0),
  max_stock_level INTEGER CHECK(max_stock_level >= 0),
  last_restock_date TIMESTAMP, -- Ultima reposición
  last_counted_at TIMESTAMP,   -- Ultimo conteo
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_inventory_product FOREIGN KEY(product_id)
    REFERENCES products(product_id)
    ON DELETE SET NULL,
  CONSTRAINT fk_inventory_warehouse FOREIGN KEY(warehouse_id)
    REFERENCES warehouses(warehouse_id)
    ON DELETE SET NULL
);
CREATE INDEX idx_product_id_and_warehouse_id ON inventory(product_id, warehouse_id);

-- Orders table
CREATE TABLE IF NOT EXISTS orders(
  order_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  order_number VARCHAR(20) UNIQUE NOT NULL,
  customer_id BIGINT NOT NULL,
  employee_id BIGINT NOT NULL,
  shipping_address_id BIGINT NOT NULL,
  order_subtotal DECIMAL(12,2) NOT NULL CHECK(order_subtotal >= 0),
  order_tax_amount DECIMAL(12,2) NOT NULL CHECK(order_tax_amount >= 0),
  order_shipping_cost DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK(order_shipping_cost >= 0),
  order_discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK(order_discount_amount >= 0),
  order_total_amount DECIMAL(12,2) NOT NULL CHECK(order_total_amount >= 0),
  order_points_redeemed INTEGER DEFAULT 0 CHECK(order_points_redeemed >= 0),
  order_payment_method payment_method NOT NULL,
  order_status order_status NOT NULL DEFAULT 'pending',
  is_invoice_require BOOLEAN DEFAULT TRUE,
  order_date TIMESTAMP NOT NULL DEFAULT NOW(), -- Fecha pedido
  order_confirmed_at TIMESTAMP,                -- Confirmación de pago
  order_processing_started_at TIMESTAMP,       -- Inicio de preparación
  order_shippend_at TIMESTAMP,                 -- Envio realizado
  order_delivered_at TIMESTAMP,                -- Entregado al cliente
  order_cancelled_at TIMESTAMP,                -- Cancelación
  order_customer_notes TEXT,
  order_internal_notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_order_customer FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_order_employee FOREIGN KEY(employee_id)
    REFERENCES employees(employee_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_order_shipping_address FOREIGN KEY(shipping_address_id)
    REFERENCES addresses(address_id)
    ON DELETE CASCADE
);
CREATE INDEX idx_order_status ON orders(order_status);

-- Orders Items table
CREATE TABLE IF NOT EXISTS order_items(
  order_item_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  item_quantity INTEGER NOT NULL CHECK(item_quantity > 0),      -- Cantidad del producto
  item_unit_price DECIMAL(12,2) NOT NULL CHECK(item_unit_price >= 0), -- Precio unitario al momento
  item_price_before_tax DECIMAL(12,2) NOT NULL CHECK(item_price_before_tax >= 0), -- Base para IVA
  item_iva_amount DECIMAL(12,2) NOT NULL CHECK(item_iva_amount >= 0),            -- IVA calculado
  item_discount_amount DECIMAL(12,2) DEFAULT 0 CHECK(item_discount_amount >= 0), -- Descuento por item
  item_line_total DECIMAL(12,2) NOT NULL CHECK(item_line_total >= 0),            -- Total linea
  fulfillment_warehouse_id BIGINT NOT NULL,       -- Bodega que despacha
  is_order_item_fulfilled BOOLEAN DEFAULT FALSE,  -- Si ya se despacho
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  CONSTRAINT fk_orderitem_order FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_orderitem_product FOREIGN KEY(product_id)
    REFERENCES products(product_id)
    ON DELETE CASCADE
);
-- Payments table
CREATE TABLE IF NOT EXISTS payments(
  payment_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  order_id BIGINT UNIQUE NOT NULL,
  payment_method payment_method NOT NULL,
  payment_amount DECIMAL(12,2) NOT NULL CHECK(payment_amount >= 0),
  payment_status payment_status NOT NULL DEFAULT 'pending',
  payment_transaction_id VARCHAR(100) UNIQUE,
  payment_authorization_code VARCHAR(50),
  payment_date TIMESTAMP,
  payment_gateway_response JSON,
  payment_failure_reason VARCHAR(250),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP,
  CONSTRAINT fk_payment_order FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE
);
-- Shipments Table
CREATE TABLE IF NOT EXISTS shipments(
  shipment_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  order_id BIGINT NOT NULL,
  shipment_carrier VARCHAR(50) NOT NULL,
  shipment_tracking_number VARCHAR(100) UNIQUE,
  shipment_service_type VARCHAR(50) UNIQUE,
  shipment_shipped_date TIMESTAMP,
  shipment_estimated_delivery_date DATE,
  shipment_actual_delivery_date DATE,
  shipment_status shipment_status DEFAULT 'pending',
  shipment_current_location VARCHAR(200),
  shipment_cost DECIMAL(10,2) CHECK(shipment_cost >= 0),
  shipment_delivery_attempts INTEGER DEFAULT 0 CHECK(shipment_delivery_attempts >= 0),
  shipment_proof_of_delivery_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT NOW(),
  updates_at TIMESTAMP,
  CONSTRAINT fk_shipment_order FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE
);
CREATE INDEX idx_shipment_tracking_number ON shipments(shipment_tracking_number);

-- Review table
CREATE TABLE IF NOT EXISTS reviews(
  review_id BIGINT GENERATED ALWAYS AS IDENTITY,
  product_id BIGINT NOT NULL,
  customer_id BIGINT NOT NULL,
  review_rating INTEGER NOT NULL CHECK(review_rating BETWEEN 1 AND 5),
  review_title VARCHAR(250),
  review_comment TEXT,
  is_review_verified_purchase BOOLEAN DEFAULT TRUE,
  review_helpful_count INTEGER DEFAULT 0 CHECK(review_helpful_count >= 0),
  review_date TIMESTAMP DEFAULT NOW(),
  review_moderator_response TEXT,
  review_images JSON,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP,
  CONSTRAINT fk_review_product FOREIGN KEY(product_id)
    REFERENCES products(product_id)
    ON DELETE CASCADE,
  CONSTRAINT fk_review_customer FOREIGN KEY(customer_id)
    REFERENCES customers(customer_id)
    ON DELETE CASCADE
);
CREATE UNIQUE INDEX idx_one_review_per_product ON reviews(customer_id, product_id);

-- Invoices table
CREATE TABLE IF NOT EXISTS invoices(
  invoice_id BIGINT GENERATED ALWAYS AS IDENTITY,
  order_id BIGINT NOT NULL,
  invoice_number VARCHAR(50) UNIQUE NOT NULL,
  invoice_cufe VARCHAR(100) UNIQUE NOT NULL,      -- Código DIAN
  invoice_qr_code VARCHAR(500) NOT NULL,
  invoice_technical_key VARCHAR(100) NOT NULL,    -- Clave técnica DIAN
  invoice_resolution_number VARCHAR(50) NOT NULL, -- Resolución DIAN
  invoice_authorization_date DATE,
  invoice_date TIMESTAMP NOT NULL DEFAULT NOW(),
  invoice_due_date DATE,                          -- Fecha vencimiento
  customer_document_type document_type NOT NULL,
  customer_document_number VARCHAR(20) NOT NULL,
  customer_name VARCHAR(200) NOT NULL,
  customer_email VARCHAR(100) NOT NULL,
  customer_address TEXT,
  invoice_subtotal DECIMAL(12,2) NOT NULL CHECK(invoice_subtotal >= 0),                      -- Base gravable
  invoice_tax_amount DECIMAL(12,2) NOT NULL CHECK(invoice_tax_amount >= 0),                  -- IVA total
  invoice_discount_amount DECIMAL(12,2) DEFAULT 0 CHECK(invoice_discount_amount >= 0),       -- Descuentos
  invoice_withholding_amount DECIMAL(12,2) DEFAULT 0 CHECK(invoice_withholding_amount >= 0), -- Retenciones
  invoice_total_amount DECIMAL(12,2) NOT NULL CHECK(invoice_total_amount >= 0),              -- Total final
  invoice_status invoice_status NOT NULL DEFAULT 'draft',
  invoice_xml_content TEXT,     -- XML firmado
  invoice_dian_response JSON,   -- Respuesta completa DIAN
  invoice_pdf_url VARCHAR(500), -- URL de visualización
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP,
  CONSTRAINT fk_invoice_order FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE
);
-- Index
CREATE INDEX IF NOT EXISTS idx_invoice_number ON invoices(invoice_number);
CREATE INDEX IF NOT EXISTS idx_invoice_customer ON invoices(customer_document_type, customer_document_number);
CREATE INDEX IF NOT EXISTS idx_invoice_order_id ON invoices(order_id);
