import 'package:flutter/material.dart';
import '../services/cart_service.dart';

String getFoodImage(String name) {
  final lower = name.toLowerCase();

  if (lower.contains('lahmacun')) return 'assets/images/lahmacun.jpg';
  if (lower.contains('pide')) return 'assets/images/pide.jpg';
  if (lower.contains('ayran')) return 'assets/images/ayran.jpg';
  if (lower.contains('su')) return 'assets/images/su.jpg';
  if (lower.contains('mercimek')) return 'assets/images/mercimek_corbasi.jpg';
  if (lower.contains('çoban')) return 'assets/images/coban_salata.jpg';
  if (lower.contains('kuru fasulye')) return 'assets/images/kuru_fasulye.jpg';
  if (lower.contains('tavuk')) return 'assets/images/tavuk_izgara.jpg';
  if (lower.contains('baklava')) return 'assets/images/baklava.jpg';
  if (lower.contains('sütlaç')) return 'assets/images/sutlac.jpg';
  if (lower.contains('kazandibi')) return 'assets/images/kazandibi.jpg';

  return 'assets/images/default_food.jpg';
}

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
            SizedBox(
              height: 320,
              width: double.infinity,
              child: Image(
                image: AssetImage(getFoodImage(item['item_name'])),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    item['image_url'] ??
                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c',
                    fit: BoxFit.cover,
                  );
                },
              ),
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
