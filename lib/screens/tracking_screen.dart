import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/session_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getDeliveries() async {
    return await supabase
        .from('deliveries')
        .select(
          'delivery_id, courier_id, status, estimated_minutes, courier_name, orders(order_id, user_id, delivery_address, city, total_price)',
        )
        .order('delivery_id', ascending: false);
  }

  Future<void> markAsDelivered(int orderId, int deliveryId) async {
    await supabase
        .from('deliveries')
        .update({'status': 'Delivered'})
        .eq('delivery_id', deliveryId);

    await supabase
        .from('orders')
        .update({'status': 'Delivered'})
        .eq('order_id', orderId);

    await supabase.from('logs').insert({
      'user_id': SessionService.userId,
      'action': 'Kurye sipariş #$orderId teslim edildi olarak işaretledi',
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kurye Takip')),
      body: FutureBuilder<List<dynamic>>(
        future: getDeliveries(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final deliveries = snapshot.data!;

          return ListView.builder(
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final delivery = deliveries[index];
              final order = delivery['orders'];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.delivery_dining),
                  title: Text('Sipariş #${order['order_id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kurye: ${delivery['courier_name'] ?? 'Atanmadı'}'),
                      Text(
                        'Tahmini süre: ${delivery['estimated_minutes'] ?? 30} dakika',
                      ),
                      Text('Adres: ${order['delivery_address']}'),
                      Text('Şehir: ${order['city']}'),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: delivery['status'] == 'Delivered'
                            ? 1.0
                            : delivery['status'] == 'On Delivery'
                            ? 0.7
                            : 0.3,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        delivery['status'] == 'Delivered'
                            ? 'Teslim Edildi'
                            : delivery['status'] == 'On Delivery'
                            ? 'Yolda'
                            : 'Hazırlanıyor',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  trailing: delivery['status'] == 'Delivered'
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : delivery['courier_id'] == SessionService.userId
                      ? ElevatedButton(
                          onPressed: () {
                            markAsDelivered(
                              order['order_id'],
                              delivery['delivery_id'],
                            );
                          },
                          child: const Text('Teslim Ettim'),
                        )
                      : const Text('Başka Kurye'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
