import 'package:flutter/material.dart';
import 'header_user.dart';
import 'footer_user.dart';

class BaseLayoutNS extends StatelessWidget {
  final Widget child;

  const BaseLayoutNS({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8F4),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const AppHeader(), // Header hijau
          const SizedBox(height: 20),

          // BODY (halaman) - tidak scrollable
          Expanded(child: child),

          const AppFooter(), // Footer hijau
        ],
      ),
    );
  }
}
