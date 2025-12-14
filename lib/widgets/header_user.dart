import 'package:flutter/material.dart';
import '../pages/user/profil_view_user.dart';
import '../pages/user/dashboard_user.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true, // ← INI YANG MENCEGAH NABRAK STATUS BAR
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Color(0xCC499B5B),
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(20),
          //   bottomRight: Radius.circular(20),
          // ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon Home
            GestureDetector(
              onTap: () {
                // Aksi ketika icon home diklik
                print("Home diklik");
                // Misal navigasi ke halaman home:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const DashboardUserPage(),
                    transitionDuration: Duration.zero, // animasi masuk
                    reverseTransitionDuration: Duration.zero, // animasi keluar
                  ),
                );
              },
              child: const Icon(Icons.home, color: Colors.white, size: 45),
            ),

            // Judul / Spacer
            const Text(
              "GASKU",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Icon Avatar
            GestureDetector(
              onTap: () {
                // Aksi ketika avatar diklik
                print("Avatar diklik");
                // Misal navigasi ke halaman profil:
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const ProfilViewUserPage(),
                    transitionDuration: Duration.zero, // animasi masuk
                    reverseTransitionDuration: Duration.zero, // animasi keluar
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Color(0xFF499B5B), size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
