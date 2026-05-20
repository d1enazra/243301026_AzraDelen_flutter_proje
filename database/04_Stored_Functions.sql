SELECT create_order(1, 650);

CREATE OR REPLACE FUNCTION create_order(
    p_user_id BIGINT,
    p_total_price NUMERIC
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO orders(user_id, total_price, status)
    VALUES (p_user_id, p_total_price, 'Preparing');
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION complete_delivery(
    p_order_id BIGINT
)
RETURNS VOID AS $$
BEGIN
    UPDATE orders
    SET status = 'Delivered'
    WHERE order_id = p_order_id;
END;
$$ LANGUAGE plpgsql;

SELECT complete_delivery(1);