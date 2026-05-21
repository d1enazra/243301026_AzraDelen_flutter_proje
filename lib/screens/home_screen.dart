import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getMenuItems() async {
    final data = await supabase.from('menu_items').select();
    return data;
  }

  Future<void> createOrder(Map item) async {
    await supabase.from('orders').insert({
      'user_id': 1,
      'total_price': item['price'],
      'status': 'Preparing',
      'delivery_address': 'Konya Merkez',
      'city': 'Konya',
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['item_name']} sipariş verildi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7fbf2),
      appBar: AppBar(
        title: const Text('Yemek Menüsü'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              );
            },
            icon: const Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getMenuItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(item['item_name']),
                  subtitle: Text('${item['category']} - ${item['price']} TL'),
                  trailing: ElevatedButton(
                    onPressed: () => createOrder(item),
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
