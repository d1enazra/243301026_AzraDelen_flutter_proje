class CartService {
  static List<Map<String, dynamic>> items = [];

  static void addItem(Map<String, dynamic> item) {
    final index = items.indexWhere((x) => x['item_id'] == item['item_id']);

    if (index >= 0) {
      items[index]['quantity'] = items[index]['quantity'] + 1;
    } else {
      items.add({...item, 'quantity': 1});
    }
  }

  static void removeItem(int itemId) {
    items.removeWhere((x) => x['item_id'] == itemId);
  }

  static void clearCart() {
    items.clear();
  }

  static double get totalPrice {
    double total = 0;
    for (var item in items) {
      total += double.parse(item['price'].toString()) * item['quantity'];
    }
    return total;
  }
}
