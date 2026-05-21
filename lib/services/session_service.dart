import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static Map<String, dynamic>? currentUser;

  static int get userId => currentUser?['user_id'] ?? 1;
  static String get fullName => currentUser?['full_name'] ?? '';
  static String get email => currentUser?['email'] ?? '';
  static String get phone => currentUser?['phone'] ?? '';
  static String get address => currentUser?['address'] ?? '';
  static String get role => currentUser?['role'] ?? 'customer';

  static Future<void> saveSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('user_id', user['user_id']);
    await prefs.setString('full_name', user['full_name'] ?? '');
    await prefs.setString('email', user['email'] ?? '');
    await prefs.setString('phone', user['phone'] ?? '');
    await prefs.setString('address', user['address'] ?? '');
    await prefs.setString('role', user['role'] ?? 'customer');

    currentUser = user;
  }

  static Future<bool> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt('user_id');
    if (userId == null) return false;

    currentUser = {
      'user_id': userId,
      'full_name': prefs.getString('full_name') ?? '',
      'email': prefs.getString('email') ?? '',
      'phone': prefs.getString('phone') ?? '',
      'address': prefs.getString('address') ?? '',
      'role': prefs.getString('role') ?? 'customer',
    };

    return true;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    currentUser = null;
  }
}
