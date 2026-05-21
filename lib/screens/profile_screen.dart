import 'package:flutter/material.dart';
import '../services/session_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7fbf2),
      appBar: AppBar(title: const Text('Profil Bilgilerim')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 45,
                    child: Icon(Icons.person, size: 50),
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  'Ad Soyad',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  SessionService.fullName,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 15),

                Text(
                  'E-posta',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  SessionService.email,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 15),

                Text(
                  'Telefon',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  SessionService.phone,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 15),

                Text(
                  'Adres',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  SessionService.address,
                  style: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 15),

                Text(
                  'Rol',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(SessionService.role, style: const TextStyle(fontSize: 18)),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Çıkış Yap'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
