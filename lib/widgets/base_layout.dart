import 'package:flutter/material.dart';
import 'header_user.dart';
import 'footer_user.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF2F8F4,
      ), // background putih kehijauan lembut
      body: Column(
        children: [
          const AppHeader(), // Header hijau
          const SizedBox(height: 20),

          // BODY (halaman)
          Expanded(child: SingleChildScrollView(child: child)),

          const AppFooter(), // Footer hijau
        ],
      ),
    );
  }
}
