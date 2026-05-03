# Sistema de Comercio Electrónico (E-Commerce Platform)

Este proyecto es un ejemplo práctico de cómo usar **Doctrine ORM** en PHP para construir una plataforma robusta de comercio electrónico. Doctrine ORM es una biblioteca de mapeo objeto-relacional que permite a los desarrolladores trabajar con bases de datos utilizando objetos, facilitando la gestión de datos complejos.

### Visión General del Sistema

Este sistema simula una plataforma completa de comercio electrónico similar a Amazon, Shopify o MercadoLibre. Maneja todo el ciclo de vida de un pedido: desde que un cliente navega productos, hasta que recibe su paquete y deja una reseña.

### Diagrama Entidad-Relación

```mermaid
erDiagram
    departments {
        int department_id PK
        string department_name
        decimal budget
        decimal spent_amount
        int manager_employee_id FK
        timestamp created_at
        timestamp updated_at
    }

    employees {
        int id PK
        string first_name
        string last_name
        string email UK
        string phone
        string document_type
        string document_number
        date hire_date
        decimal salary
        decimal commission_pct
        int department_id FK
        int manager_employee_id FK
        boolean is_employee_active
        timestamp created_at
        timestamp updated_at
    }

    customers {
        int id PK
        string first_name
        string last_name
        string email UK
        string phone
        string document_type
        string document_number
        boolean is_company
        string tax_regime
        timestamp registration_date
        int loyalty_points
        int total_orders
        decimal total_spent
        boolean is_vip
        timestamp created_at
        timestamp updated_at
    }

    addresses {
        int id PK
        int customer_id FK
        string type
        string street
        string neighborhood
        string city
        string department
        string postal_code
        string country
        text reference
        decimal latitude
        decimal longitude
        boolean is_default_address
        timestamp created_at
        timestamp updated_at
    }

    warehouses {
        int id PK
        string warehouse_name
        string warehouse_code UK
        string address
        string neighborhood
        string city
        string department
        string postal_code
        string phone
        string email
        int manager_employee_id FK
        boolean is_warehouse_active
        int warehouse_capacity_units
        string warehouse_operating_hours
        timestamp created_at
        timestamp updated_at
    }

    categories {
        int id PK
        string category_name
        string category_slug UK
        int parent_id FK
        text description
        int display_order
        string image_url
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    products {
        int id PK
        string product_sku UK
        string product_barcode UK
        string product_name
        text description
        string short_description
        int category_id FK
        decimal base_price
        decimal discount_price
        decimal product_cost
        decimal product_iva_rate
        boolean product_is_taxable
        decimal product_weight
        string product_dimensions
        int stock_quantity
        int product_units_sold
        int product_reorder_level
        decimal rating_average
        int rating_count
        boolean is_active
        boolean is_featured
        json product_images
        string product_tags
        timestamp created_at
        timestamp updated_at
    }

    inventory {
        int id PK
        int product_id FK
        int warehouse_id FK
        int quantity_on_hand
        int quantity_reserved
        int quantity_available
        int reorder_point
        int max_stock_level
        timestamp last_restock_date
        timestamp last_counted_at
        timestamp created_at
        timestamp updated_at
    }

    orders {
        int id PK
        string order_number UK
        int customer_id FK
        int employee_id FK
        int shipping_address_id FK
        decimal order_subtotal
        decimal order_tax_amount
        decimal order_shipping_cost
        decimal order_discount_amount
        decimal order_total_amount
        int order_points_earned
        int order_points_redeemed
        string order_payment_method
        string order_status
        boolean is_invoice_required
        timestamp order_date
        timestamp order_confirmed_at
        timestamp order_processing_started_at
        timestamp order_shipped_at
        timestamp order_delivered_at
        timestamp order_cancelled_at
        text order_customer_notes
        text order_internal_notes
        timestamp created_at
        timestamp updated_at
    }

    order_items {
        int id PK
        int order_id FK
        int product_id FK
        int item_quantity
        decimal item_unit_price
        decimal item_price_before_tax
        decimal item_iva_amount
        decimal item_discount_amount
        decimal item_line_total
        int fulfillment_warehouse_id FK
        boolean is_order_item_fulfilled
        timestamp created_at
        timestamp updated_at
    }

    payments {
        int id PK
        int order_id FK
        string payment_method
        decimal payment_amount
        string payment_status
        string payment_transaction_id UK
        string payment_authorization_code
        timestamp payment_date
        json payment_gateway_response
        string payment_failure_reason
        timestamp created_at
        timestamp updated_at
    }

    shipments {
        int id PK
        int order_id FK
        string shipment_carrier
        string shipment_tracking_number UK
        string shipment_service_type
        timestamp shipment_shipped_date
        date shipment_estimated_delivery_date
        date shipment_actual_delivery_date
        string shipment_status
        string shipment_current_location
        decimal shipment_cost
        int shipment_delivery_attempts
        string shipment_proof_of_delivery_url
        timestamp created_at
        timestamp updated_at
    }

    reviews {
        int id PK
        int product_id FK
        int customer_id FK
        int review_rating
        string review_title
        text review_comment
        boolean is_review_verified_purchase
        int review_helpful_count
        timestamp review_date
        text review_moderator_response
        json review_images
        timestamp created_at
        timestamp updated_at
    }

    invoices {
        int id PK
        int order_id FK
        string invoice_number UK
        string invoice_cufe UK
        string invoice_qr_code
        string invoice_technical_key
        string invoice_resolution_number
        date invoice_authorization_date
        timestamp invoice_date
        date invoice_due_date
        string invoice_customer_document_type
        string invoice_customer_document_number
        string invoice_customer_name
        string invoice_customer_email
        text invoice_customer_address
        decimal invoice_subtotal
        decimal invoice_tax_amount
        decimal invoice_discount_amount
        decimal invoice_withholding_amount
        decimal invoice_total_amount
        string invoice_status
        text invoice_xml_content
        json invoice_dian_response
        string invoice_pdf_url
        timestamp created_at
        timestamp updated_at
    }

    %% Relaciones
    employees ||--o{ departments : "manages"
    departments ||--o{ employees : "belongs to"
    employees ||--o{ employees : "reports to"
    customers ||--o{ addresses : "has"
    employees ||--o{ warehouses : "manages"
    categories ||--o{ categories : "sub-category"
    categories ||--o{ products : "categorizes"
    products ||--o{ inventory : "in stock"
    warehouses ||--o{ inventory : "stores"
    orders ||--o{ order_items : "includes"
    products ||--o{ order_items : "item"
    warehouses ||--o{ order_items : "fulfills"
    customers ||--o{ orders : "places"
    employees ||--o{ orders : "handles"
    addresses ||--o{ orders : "ships to"
    orders ||--o{ payments : "paid by"
    orders ||--o{ shipments : "delivered via"
    products ||--o{ reviews : "reviewed"
    customers ||--o{ reviews : "authored"
    orders ||--o{ invoices : "billed as"
```
