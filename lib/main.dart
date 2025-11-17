import 'package:flutter/material.dart';
import 'pages/admin/makedistributor.dart'; // pastikan file register_page.dart disimpan di folder lib/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hilangkan banner debug
      title: 'Halaman Registrasi Distributor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const RegisterDistributorPage(), // arahkan ke halaman register
    );
  }
}
