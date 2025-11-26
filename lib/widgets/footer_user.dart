import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF6BB57A),
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
      ),
      child: const Text(
        "©2025 Copyright: GasKu",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
