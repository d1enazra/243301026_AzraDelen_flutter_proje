INSERT INTO menu_items 
(item_name, description, price, category, stock_quantity, image_url)
VALUES
('Tavuk Izgara', 'Pilav ve salata ile tavuk ızgara', 180.00, 'Ana Yemek', 40, ''),
('Et Döner Menü', 'Et döner, patates ve içecek', 220.00, 'Ana Yemek', 35, ''),
('Köfte Menü', 'Izgara köfte, pilav ve salata', 200.00, 'Ana Yemek', 30, ''),
('Makarna', 'Domates soslu makarna', 120.00, 'Ana Yemek', 50, ''),
('Mercimek Çorbası', 'Sıcak mercimek çorbası', 70.00, 'Çorba', 60, ''),
('Ezogelin Çorbası', 'Geleneksel ezogelin çorbası', 75.00, 'Çorba', 55, ''),
('Sezar Salata', 'Tavuklu sezar salata', 140.00, 'Salata', 25, ''),
('Çoban Salata', 'Domates, salatalık ve soğan', 90.00, 'Salata', 40, ''),
('Lahmacun', 'Acılı lahmacun', 85.00, 'Fast Food', 70, ''),
('Pide', 'Kaşarlı pide', 150.00, 'Fast Food', 45, ''),
('Ayran', 'Soğuk ayran', 25.00, 'İçecek', 100, ''),
('Kola', '330 ml kola', 35.00, 'İçecek', 90, ''),
('Su', '500 ml su', 15.00, 'İçecek', 120, ''),
('Sütlaç', 'Fırın sütlaç', 80.00, 'Tatlı', 30, ''),
('Baklava', 'Fıstıklı baklava', 110.00, 'Tatlı', 25, '');

INSERT INTO orders (user_id, total_price, status)
VALUES
(2, 180, 'Preparing'),
(3, 250, 'Delivered'),
(4, 120, 'On Delivery'),
(5, 300, 'Preparing'),
(6, 450, 'Delivered'),
(7, 210, 'Preparing'),
(8, 175, 'Delivered'),
(9, 500, 'On Delivery'),
(10, 340, 'Preparing'),
(11, 280, 'Delivered'),
(12, 190, 'Preparing'),
(13, 600, 'Delivered');

INSERT INTO order_details
(order_id, item_id, quantity, unit_price)
SELECT order_id, 1, 1, 180.00 FROM orders LIMIT 5;

INSERT INTO order_details
(order_id, item_id, quantity, unit_price)
SELECT order_id, 2, 1, 250.00 FROM orders OFFSET 5 LIMIT 5;

INSERT INTO order_details
(order_id, item_id, quantity, unit_price)
SELECT order_id, 3, 2, 25.00 FROM orders OFFSET 10 LIMIT 5;

INSERT INTO users (full_name, email, role, phone, address)
VALUES
('Ahmet Yılmaz', 'ahmet1@gmail.com', 'customer', '5550000001', 'Konya'),
('Ayşe Demir', 'ayse2@gmail.com', 'customer', '5550000002', 'Ankara'),
('Mehmet Kaya', 'mehmet3@gmail.com', 'customer', '5550000003', 'İstanbul'),
('Fatma Şahin', 'fatma4@gmail.com', 'customer', '5550000004', 'İzmir'),
('Ali Çelik', 'ali5@gmail.com', 'courier', '5550000005', 'Konya'),
('Zeynep Arslan', 'zeynep6@gmail.com', 'customer', '5550000006', 'Bursa'),
('Mustafa Koç', 'mustafa7@gmail.com', 'customer', '5550000007', 'Antalya'),
('Elif Yıldız', 'elif8@gmail.com', 'customer', '5550000008', 'Adana'),
('Burak Aydın', 'burak9@gmail.com', 'courier', '5550000009', 'Konya'),
('Merve Aksoy', 'merve10@gmail.com', 'customer', '5550000010', 'Kayseri'),
('Can Karaca', 'can11@gmail.com', 'customer', '5550000011', 'Samsun'),
('Ece Kurt', 'ece12@gmail.com', 'customer', '5550000012', 'Trabzon'),
('Emre Öz', 'emre13@gmail.com', 'customer', '5550000013', 'Eskişehir');

INSERT INTO deliveries
(order_id, courier_name, status)
SELECT order_id, 'Ali Çelik', 'Delivered'
FROM orders
LIMIT 5;

INSERT INTO deliveries
(order_id, courier_name, status)
SELECT order_id, 'Burak Aydın', 'On Delivery'
FROM orders
OFFSET 5 LIMIT 5;

INSERT INTO deliveries
(order_id, courier_name, status)
SELECT order_id, 'Ali Çelik', 'Preparing'
FROM orders
OFFSET 10 LIMIT 5;