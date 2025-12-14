import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:project_gasku/login_page.dart';
import 'package:project_gasku/pages/user/profil_view_user.dart';
import 'package:project_gasku/providers/user.dart';
import '/widgets/base_layout.dart';

enum MenuOptions { profile, logout }

class StokGasPage extends ConsumerWidget {
  const StokGasPage({super.key});

  Future<Map<String, dynamic>> getGas(String token) async {
    final apiUrl = 'http://localhost:8000/api/gas/get';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data gas');
    }

    final decoded = jsonDecode(response.body);
    return decoded['data'][0];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(UserProvider);

    return Scaffold(
      // =========================
      // APPBAR (SAMA DENGAN BERANDA)
      // =========================
      // appBar: AppBar(
      //   toolbarHeight: 80.0,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: const Color.fromRGBO(73, 155, 91, 0.8),
      //   title: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       const Icon(Icons.home_filled, color: Colors.white, size: 38),

      //       const Text(
      //         "GASKU",
      //         style: TextStyle(
      //           color: Colors.white,
      //           fontWeight: FontWeight.bold,
      //           fontFamily: 'Poppins',
      //           letterSpacing: 2.5,
      //         ),
      //       ),

      //       PopupMenuButton<MenuOptions>(
      //         icon: const Icon(
      //           Icons.account_circle,
      //           color: Colors.white,
      //           size: 40,
      //         ),
      //         onSelected: (MenuOptions result) {
      //           switch (result) {
      //             case MenuOptions.profile:
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (_) => const ProfilViewUserPage(),
      //                 ),
      //               );
      //               break;

      //             case MenuOptions.logout:
      //               Navigator.pushAndRemoveUntil(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (_) => const LoginPage(),
      //                 ),
      //                 (route) => false,
      //               );
      //               break;
      //           }
      //         },
      //         itemBuilder: (_) => const [
      //           PopupMenuItem<MenuOptions>(
      //             value: MenuOptions.profile,
      //             child: Row(
      //               children: [
      //                 Icon(Icons.person, color: Colors.black54),
      //                 SizedBox(width: 8),
      //                 Text('Profil'),
      //               ],
      //             ),
      //           ),
      //           PopupMenuItem<MenuOptions>(
      //             value: MenuOptions.logout,
      //             child: Row(
      //               children: [
      //                 Icon(Icons.logout, color: Colors.red),
      //                 SizedBox(width: 8),
      //                 Text(
      //                   'Keluar',
      //                   style: TextStyle(color: Colors.red),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),

      // =========================
      // BODY (ISI HALAMAN GAS)
      // =========================
      body: BaseLayout(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 260,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (user.username.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Halo, ${user.username}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                  FutureBuilder<Map<String, dynamic>>(
                    future: getGas(user.token),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final gas = snapshot.data!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.2,
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                "Pengumuman",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF65916F),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                gas['pengumuman'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF5D7F27),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Stok: ${gas['stok']} | Harga: Rp${gas['harga']}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF6EAF7C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
