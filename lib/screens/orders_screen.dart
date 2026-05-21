import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        .select()
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data ?? [];

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(
                    'Sipariş #${order['order_id']} - ${order['total_price']} TL',
                  ),
                  subtitle: Text(
                    'Durum: ${order['status']}\n'
                    'Şehir: ${order['city']}\n'
                    'Adres: ${order['delivery_address']}',
                    style: TextStyle(
                      color: order['status'] == 'Delivered'
                          ? Colors.green
                          : order['status'] == 'On Delivery'
                          ? Colors.orange
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
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
