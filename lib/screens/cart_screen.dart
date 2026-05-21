import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/cart_service.dart';
import '../services/session_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final supabase = Supabase.instance.client;
  String paymentMethod = 'Kapıda Ödeme';

  Future<void> confirmOrder() async {
    if (CartService.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sepet boş')));
      return;
    }

    final addressController = TextEditingController(
      text: SessionService.address,
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Siparişi Onayla'),
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
                      'total_price': CartService.totalPrice,
                      'status': 'Preparing',
                      'delivery_address': addressController.text.trim(),
                      'city': 'Konya',
                      'payment_method': paymentMethod,
                    })
                    .select()
                    .single();

                for (var item in CartService.items) {
                  await supabase.from('order_details').insert({
                    'order_id': insertedOrder['order_id'],
                    'item_id': item['item_id'],
                    'quantity': item['quantity'],
                    'unit_price': item['price'],
                  });
                }

                await supabase.from('deliveries').insert({
                  'order_id': insertedOrder['order_id'],
                  'courier_id': 5,
                  'courier_name': 'Ali Çelik',
                  'status': 'Preparing',
                  'estimated_minutes': 35,
                });

                CartService.clearCart();

                if (!mounted) return;

                Navigator.pop(context);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sipariş oluşturuldu')),
                );
              },
              child: const Text('Onayla'),
            ),
          ],
        );
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final items = CartService.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Sepetim')),
      body: items.isEmpty
          ? const Center(child: Text('Sepet boş'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text(item['item_name']),
                    subtitle: Text(
                      'Adet: ${item['quantity']} - ${item['price']} TL',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        CartService.removeItem(item['item_id']);
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: confirmOrder,
          child: Text(
            'Siparişi Onayla - ${CartService.totalPrice.toStringAsFixed(2)} TL',
          ),
        ),
      ),
    );
  }
}
