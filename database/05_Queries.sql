SELECT 
    o.order_id,
    u.full_name,
    u.role,
    o.total_price,
    o.status,
    o.order_date
FROM orders o
JOIN users u ON o.user_id = u.user_id
ORDER BY o.order_date DESC;


SELECT 
    o.order_id,
    u.full_name,
    m.item_name,
    od.quantity,
    od.unit_price,
    (od.quantity * od.unit_price) AS total_price
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN users u ON o.user_id = u.user_id
JOIN menu_items m ON od.item_id = m.item_id;


SELECT 
    m.item_name,
    SUM(od.quantity) AS total_sold
FROM order_details od
JOIN menu_items m ON od.item_id = m.item_id
GROUP BY m.item_name
ORDER BY total_sold DESC;


SELECT 
    u.full_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_price) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE u.role = 'customer'
GROUP BY u.full_name
HAVING SUM(o.total_price) > 200
ORDER BY total_spent DESC;


SELECT 
    status,
    COUNT(*) AS delivery_count
FROM deliveries
GROUP BY status;

SELECT
    d.delivery_id,
    o.order_id,
    customer.full_name AS customer_name,
    courier.full_name AS courier_name,
    o.city,
    o.delivery_address,
    d.status AS delivery_status
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN users customer ON o.user_id = customer.user_id
JOIN users courier ON d.courier_id = courier.user_id;