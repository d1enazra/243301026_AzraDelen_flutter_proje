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

    await supabase
        .from('deliveries')
        .update({'status': status})
        .eq('order_id', orderId);

    await supabase.from('logs').insert({
      'user_id': 1,
      'action': 'Admin sipariş #$orderId durumunu $status yaptı',
    });

    setState(() {});
  }

  Future<void> assignCourier(int orderId) async {
    final couriers = await supabase
        .from('users')
        .select()
        .eq('role', 'courier');

    String? selectedCourierId;
    String? selectedCourierName;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Kurye Ata'),
          content: DropdownButtonFormField<String>(
            items: couriers.map<DropdownMenuItem<String>>((courier) {
              return DropdownMenuItem<String>(
                value: courier['user_id'].toString(),
                child: Text(courier['full_name']),
              );
            }).toList(),
            onChanged: (value) {
              final courier = couriers.firstWhere(
                (c) => c['user_id'].toString() == value,
              );

              selectedCourierId = courier['user_id'].toString();
              selectedCourierName = courier['full_name'];
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await supabase
                    .from('deliveries')
                    .update({
                      'courier_id': int.parse(selectedCourierId!),
                      'courier_name': selectedCourierName,
                      'status': 'On Delivery',
                    })
                    .eq('order_id', orderId);

                await supabase
                    .from('orders')
                    .update({'status': 'On Delivery'})
                    .eq('order_id', orderId);

                if (!mounted) return;

                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Kurye Ata'),
            ),
          ],
        );
      },
    );
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          assignCourier(order['order_id']);
                        },
                        child: const Text('Kurye Ata'),
                      ),

                      const SizedBox(width: 8),

                      PopupMenuButton<String>(
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
