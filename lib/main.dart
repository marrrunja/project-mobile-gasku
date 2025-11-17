import 'package:flutter/material.dart';
import 'login_page.dart';

import 'pages/admin/makedistributor.dart'; // pastikan file register_page.dart disimpan di folder lib/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      title: 'Halaman Registrasi Distributor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(99, 166, 80, 1),
        ),
        useMaterial3: true,
      ), // arahkan ke halaman register
    );
  }
}
