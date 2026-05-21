import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final supabase = Supabase.instance.client;

  Future<List<dynamic>> getLogs() async {
    final data = await supabase
        .from('logs')
        .select()
        .order('log_id', ascending: false);

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sistem Logları')),
      body: FutureBuilder<List<dynamic>>(
        future: getLogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          final logs = snapshot.data ?? [];
          if (logs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Log kaydı bulunamadı', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(log['action']),
                  subtitle: Text('User ID: ${log['user_id']}'),
                  trailing: Text('${log['log_id']}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
