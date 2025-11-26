import 'package:flutter/material.dart';

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
            const Icon(Icons.home, color: Colors.white, size: 40),

            Row(
              children: [
                // Image.asset("assets/gaslogo.png", width: 40), pake image eror mulu bangsaat
                const SizedBox(width: 8),
                const Text(
                  "GASKU",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Icon(Icons.person, color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }
}
