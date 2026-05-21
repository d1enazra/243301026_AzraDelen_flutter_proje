class SessionService {
  static Map<String, dynamic>? currentUser;

  static int get userId => currentUser?['user_id'] ?? 1;
  static String get fullName => currentUser?['full_name'] ?? '';
  static String get email => currentUser?['email'] ?? '';
  static String get phone => currentUser?['phone'] ?? '';
  static String get address => currentUser?['address'] ?? '';
  static String get role => currentUser?['role'] ?? 'customer';
}
