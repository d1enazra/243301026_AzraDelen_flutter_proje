import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getMenuItems() async {
    return await supabase
        .from('menu_items')
        .select()
        .order('item_id', ascending: false);
  }

  Future<void> addMenuItem() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    String category = 'Fast Food';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Yemek Ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Yemek Adı'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Açıklama'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Fiyat'),
                ),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Stok'),
                ),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Kategori'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Fast Food',
                      child: Text('Fast Food'),
                    ),
                    DropdownMenuItem(
                      value: 'Ev Yemekleri',
                      child: Text('Ev Yemekleri'),
                    ),
                    DropdownMenuItem(
                      value: 'İçecekler',
                      child: Text('İçecekler'),
                    ),
                    DropdownMenuItem(
                      value: 'Tatlılar',
                      child: Text('Tatlılar'),
                    ),
                  ],
                  onChanged: (value) {
                    category = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await supabase.from('menu_items').insert({
                  'item_name': nameController.text.trim(),
                  'description': descriptionController.text.trim(),
                  'price': double.tryParse(priceController.text.trim()) ?? 0,
                  'category': category,
                  'stock_quantity':
                      int.tryParse(stockController.text.trim()) ?? 0,
                });

                if (!mounted) return;
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateItem(Map item) async {
    final priceController = TextEditingController(
      text: item['price'].toString(),
    );
    final stockController = TextEditingController(
      text: item['stock_quantity'].toString(),
    );

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${item['item_name']} Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yeni Fiyat'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yeni Stok'),
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
                await supabase
                    .from('menu_items')
                    .update({
                      'price':
                          double.tryParse(priceController.text.trim()) ??
                          item['price'],
                      'stock_quantity':
                          int.tryParse(stockController.text.trim()) ??
                          item['stock_quantity'],
                    })
                    .eq('item_id', item['item_id']);

                if (!mounted) return;
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteItem(int itemId) async {
    await supabase.from('menu_items').delete().eq('item_id', itemId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menü Yönetimi')),
      floatingActionButton: FloatingActionButton(
        onPressed: addMenuItem,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getMenuItems(),
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
                    '${item['category']} - ${item['price']} TL\nStok: ${item['stock_quantity']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => updateItem(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteItem(item['item_id']),
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
