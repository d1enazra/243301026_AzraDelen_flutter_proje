import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/login_screen.dart';
import 'screens/category_screen.dart';
import 'services/session_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jkcsyufmjwnocaxbtsny.supabase.co',
    anonKey: 'sb_publishable_fZ4ppGLZlnGgOvIueBNWMw_LV4xcptv',
  );

  final hasSession = await SessionService.loadSession();

  runApp(MyApp(hasSession: hasSession));
}

class MyApp extends StatelessWidget {
  final bool hasSession;

  const MyApp({super.key, required this.hasSession});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Catering Sipariş Takibi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: hasSession ? const CategoryScreen() : const LoginScreen(),
    );
  }
}
