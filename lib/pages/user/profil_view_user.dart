import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '/widgets/base_layout.dart';
import '../../providers/user.dart';
import 'profil_edit_user.dart';
import '../../login_page.dart';

class ProfilViewUserPage extends ConsumerWidget {
  const ProfilViewUserPage({super.key});

  // =========================
  // GET USER DARI API
  // =========================
  Future<Map<String, dynamic>> getUser(String token) async {
    const apiUrl = 'http://localhost:8000/api/me';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data user');
    }

    final decoded = jsonDecode(response.body);
    return decoded['user']; // sesuai response API kamu
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authUser = ref.watch(UserProvider); // hanya ambil token

    return BaseLayout(
      child: FutureBuilder<Map<String, dynamic>>(
        future: getUser(authUser.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(40),
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

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 260,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // =========================
                    // CARD PROFIL
                    // =========================
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xCC499B5B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          // Avatar
                          const CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 45,
                              color: Color(0xFF5FA777),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Nama User
                          Text(
                            user['username'] ?? '-',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // =========================
                          // INFORMASI USER
                          // =========================
                          Table(
                            columnWidths: const {
                              0: FixedColumnWidth(80),
                              1: FixedColumnWidth(10),
                              2: FlexColumnWidth(),
                            },
                            children: [
                              _buildTableRow(
                                "Email",
                                user['email'] ?? '-',
                              ),
                              _buildSpacerRow(),
                              _buildTableRow(
                                "No. KK",
                                user['no_kk'] ?? '-',
                              ),
                              _buildSpacerRow(),
                              _buildTableRow(
                                "Alamat",
                                user['alamat_lengkap'] ?? '-',
                              ),
                               _buildSpacerRow(),
                              _buildTableRow(
                                "Jenis",
                                user['jenis_user'] == 1 ? 'Distributor':'Pembeli',
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // =========================
                          // BUTTON EDIT & LOGOUT
                          // =========================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 120,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            const ProfilEditUserPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFFFC93C),
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text(
                                    "EDIT",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            const LoginPage(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text(
                                    "LOGOUT",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================
  // HELPER TABLE ROW
  // =========================
  static TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Text(
          ":",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  static TableRow _buildSpacerRow() {
    return const TableRow(
      children: [
        SizedBox(height: 25),
        SizedBox(),
        SizedBox(),
      ],
    );
  }
}
