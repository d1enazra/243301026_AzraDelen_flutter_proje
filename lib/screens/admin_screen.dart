import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getOrders() async {
    return await supabase
        .from('orders')
        .select()
        .order('order_id', ascending: false);
  }

  Future<void> updateStatus(int orderId, String status) async {
    await supabase
        .from('orders')
        .update({'status': status})
        .eq('order_id', orderId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Sipariş Yönetimi')),
      body: FutureBuilder<List<dynamic>>(
        future: getOrders(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    'Sipariş #${order['order_id']} - ${order['total_price']} TL',
                  ),
                  subtitle: Text(
                    '${order['status']} - ${order['city']}',
                    style: TextStyle(
                      color: order['status'] == 'Delivered'
                          ? Colors.green
                          : order['status'] == 'On Delivery'
                          ? Colors.orange
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      updateStatus(order['order_id'], value);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'Preparing',
                        child: Text('Preparing'),
                      ),
                      PopupMenuItem(
                        value: 'On Delivery',
                        child: Text('On Delivery'),
                      ),
                      PopupMenuItem(
                        value: 'Delivered',
                        child: Text('Delivered'),
                      ),
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
