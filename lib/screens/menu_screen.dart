import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/session_service.dart';

class MenuScreen extends StatefulWidget {
  final String category;

  const MenuScreen({super.key, required this.category});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getItems() async {
    return await supabase
        .from('menu_items')
        .select()
        .eq('category', widget.category);
  }

  Future<void> orderItem(Map item) async {
    String paymentMethod = 'Kapıda Ödeme';
    final addressController = TextEditingController(
      text: SessionService.address,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${item['item_name']} Siparişi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Müşteri: ${SessionService.fullName}'),
              Text('Telefon: ${SessionService.phone}'),
              const SizedBox(height: 12),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Teslimat Adresi'),
              ),
              DropdownButtonFormField<String>(
                value: paymentMethod,
                items: const [
                  DropdownMenuItem(
                    value: 'Kapıda Ödeme',
                    child: Text('Kapıda Ödeme'),
                  ),
                  DropdownMenuItem(
                    value: 'Kredi Kartı',
                    child: Text('Kredi Kartı'),
                  ),
                ],
                onChanged: (value) {
                  paymentMethod = value!;
                },
                decoration: const InputDecoration(labelText: 'Ödeme Türü'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final insertedOrder = await supabase
                    .from('orders')
                    .insert({
                      'user_id': SessionService.userId,
                      'total_price': item['price'],
                      'status': 'Preparing',
                      'delivery_address': addressController.text.trim(),
                      'city': 'Konya',
                      'payment_method': paymentMethod,
                    })
                    .select()
                    .single();

                await supabase.from('order_details').insert({
                  'order_id': insertedOrder['order_id'],
                  'item_id': item['item_id'],
                  'quantity': 1,
                  'unit_price': item['price'],
                });

                await supabase.from('deliveries').insert({
                  'order_id': insertedOrder['order_id'],
                  'courier_id': 5,
                  'courier_name': 'Ali Çelik',
                  'status': 'Preparing',
                  'estimated_minutes': 35,
                });

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item['item_name']} sipariş edildi'),
                  ),
                );
              },
              child: const Text('Siparişi Onayla'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: FutureBuilder<List<dynamic>>(
        future: getItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(item['item_name']),
                  subtitle: Text(
                    '${item['description'] ?? ''}\n${item['price']} TL',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => orderItem(item),
                    child: const Text('Sipariş Ver'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
