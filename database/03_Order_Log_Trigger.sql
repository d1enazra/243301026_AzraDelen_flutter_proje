CREATE TRIGGER trg_order_insert
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION log_new_order();

CREATE OR REPLACE FUNCTION log_new_order()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO logs (user_id, action)
    VALUES (NEW.user_id, 'New order created');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;