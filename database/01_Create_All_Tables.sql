CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name TEXT,
    email TEXT UNIQUE,
    role TEXT,
    phone TEXT,
    address TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE menu_items (
    item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_name TEXT NOT NULL,
    description TEXT,
    price NUMERIC(10,2),
    category TEXT,
    stock_quantity INT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT,
    total_price NUMERIC(10,2),
    status TEXT,
    order_date TIMESTAMP DEFAULT NOW(),

    CONSTRAINT fk_user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
);

CREATE TABLE order_details (
    detail_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT,
    item_id BIGINT,
    quantity INT,
    unit_price NUMERIC(10,2),

    CONSTRAINT fk_order
        FOREIGN KEY(order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item
        FOREIGN KEY(item_id)
        REFERENCES menu_items(item_id)
        ON DELETE CASCADE
);

CREATE TABLE deliveries (
    delivery_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT,
    courier_name TEXT,
    status TEXT,
    delivery_time TIMESTAMP DEFAULT NOW()
);

CREATE TABLE logs (
    log_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT,
    action TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);