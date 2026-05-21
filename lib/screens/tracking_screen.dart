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
          'delivery_id, status, estimated_minutes, courier_name, orders(order_id, user_id, delivery_address, city, total_price)',
        )
        .order('delivery_id', ascending: false);
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
                  subtitle: Text(
                    'Kurye: ${delivery['courier_name'] ?? 'Atanmadı'}\n'
                    'Durum: ${delivery['status']}\n'
                    'Tahmini süre: ${delivery['estimated_minutes'] ?? 30} dakika\n'
                    'Adres: ${order['delivery_address']}\n'
                    'Şehir: ${order['city']}',
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
