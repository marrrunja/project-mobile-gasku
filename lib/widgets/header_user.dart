import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_gasku/providers/user.dart';
import 'package:http/http.dart' as http;
import '../pages/user/profil_view_user.dart';
import '../login_page.dart';
import 'dart:convert';

enum MenuOptions { profile, logout }

class AppHeader extends ConsumerWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(UserProvider);

    // Fungsi logout
    Future<void> _logout() async {
      final token = user.token;
      if (token.isEmpty) return;

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8000/api/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          // Hapus data user di provider
          ref.read(UserProvider.notifier).clear();

          final decoded = jsonDecode(response.body);
          final message = decoded['message'] ?? 'Logout berhasil';

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
              ),
            );

            // Navigasi ke LoginPage dan hapus semua halaman sebelumnya
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
              (route) => false,
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Logout gagal: ${response.statusCode}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saat logout: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return AppBar(
      toolbarHeight: 80.0,
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromRGBO(73, 155, 91, 0.8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // KIRI: HOME
          GestureDetector(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Icon(Icons.home_filled, color: Colors.white, size: 38),
          ),

          // TENGAH: JUDUL
          const Text(
            "GASKU",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              letterSpacing: 2.5,
            ),
          ),

          // KANAN: MENU PROFIL
          PopupMenuButton<MenuOptions>(
            icon: const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 40,
            ),
            onSelected: (MenuOptions result) {
              switch (result) {
                case MenuOptions.profile:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilViewUserPage(),
                    ),
                  );
                  break;

                case MenuOptions.logout:
                  _logout(); // Panggil fungsi logout di sini
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem<MenuOptions>(
                value: MenuOptions.profile,
                child: Row(
                  children: [
                    Icon(Icons.person, color: Colors.black54),
                    SizedBox(width: 8),
                    Text('Profil'),
                  ],
                ),
              ),
              PopupMenuItem<MenuOptions>(
                value: MenuOptions.logout,
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Keluar', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
