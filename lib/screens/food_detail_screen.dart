import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class FoodDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const FoodDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final stock = item['stock_quantity'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text(item['item_name'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              item['image_url'] ??
                  'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['item_name'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    item['description'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item['price']} TL',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      Text(
                        'Stok: $stock',
                        style: TextStyle(
                          fontSize: 18,
                          color: stock > 0 ? Colors.black : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: stock <= 0
                        ? ElevatedButton(
                            onPressed: null,
                            child: const Text('Tükendi'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              CartService.addItem(item);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${item['item_name']} sepete eklendi',
                                  ),
                                ),
                              );
                            },
                            child: const Text('Sepete Ekle'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
