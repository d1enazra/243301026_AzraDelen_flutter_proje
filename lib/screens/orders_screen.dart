import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/session_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getOrders() async {
    final data = await supabase
        .from('orders')
        .select('''
          order_id,
          total_price,
          status,
          city,
          delivery_address,
          payment_method,
          order_details(
            quantity,
            unit_price,
            menu_items(item_name)
          )
        ''')
        .eq('user_id', SessionService.userId)
        .order('order_id', ascending: false);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Siparişlerim')),
      body: FutureBuilder<List<dynamic>>(
        future: getOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Henüz siparişiniz yok', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              final details = order['order_details'] as List<dynamic>? ?? [];

              final productText = details
                  .map((detail) {
                    final menuItem = detail['menu_items'];
                    return '${detail['quantity']} x ${menuItem?['item_name'] ?? 'Ürün'}';
                  })
                  .join(', ');

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(
                    'Sipariş #${order['order_id']} - ${order['total_price']} TL',
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ürünler: $productText'),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(order['status']),
                        backgroundColor: order['status'] == 'Delivered'
                            ? Colors.green.shade100
                            : order['status'] == 'On Delivery'
                            ? Colors.orange.shade100
                            : Colors.red.shade100,
                      ),
                      Text('Ödeme: ${order['payment_method'] ?? '-'}'),
                      Text('Şehir: ${order['city']}'),
                      Text('Adres: ${order['delivery_address']}'),
                    ],
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
