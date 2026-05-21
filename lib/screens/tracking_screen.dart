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
    var query = supabase
        .from('deliveries')
        .select(
          'delivery_id, courier_id, status, estimated_minutes, courier_name, orders(order_id, user_id, delivery_address, city, total_price)',
        );

    if (SessionService.role == 'customer') {
      query = query.eq('orders.user_id', SessionService.userId);
    }

    if (SessionService.role == 'courier') {
      query = query.eq('courier_id', SessionService.userId);
    }

    return await query.order('delivery_id', ascending: false);
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
          if (deliveries.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delivery_dining, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Teslimat kaydı bulunamadı',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }

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
                      Chip(
                        label: Text(
                          delivery['status'] == 'Delivered'
                              ? 'Teslim Edildi'
                              : delivery['status'] == 'On Delivery'
                              ? 'Yolda'
                              : 'Hazırlanıyor',
                        ),
                        backgroundColor: delivery['status'] == 'Delivered'
                            ? Colors.green.shade100
                            : delivery['status'] == 'On Delivery'
                            ? Colors.orange.shade100
                            : Colors.red.shade100,
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
