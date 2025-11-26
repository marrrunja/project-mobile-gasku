import 'package:flutter/material.dart';
import '/widgets/base_layout.dart';
import 'profil_edit_user.dart';

class ProfilViewUserPage extends StatelessWidget {
  const ProfilViewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 260,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mulai card profil
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xCC499B5B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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

                      // Nama & ID
                      const Text(
                        "PEOPLE +62",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Table 3 kolom untuk informasi
                      Table(
                        columnWidths: const {
                          0: FixedColumnWidth(80), // label
                          1: FixedColumnWidth(10), // separator
                          2: FlexColumnWidth(), // value
                        },
                        children: [
                          _buildTableRow("Email", "people.+62@gmail.com"),
                          _buildSpacerRow(),
                          _buildTableRow("No. KK", "012345678901112"),
                          _buildSpacerRow(),
                          _buildTableRow("No. Telp", "083197904758"),
                          _buildSpacerRow(),
                          _buildTableRow(
                            "Alamat",
                            "katanya jalanin aja dulu, tapi sekarang malah pisah jalan",
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Tombol Edit
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
                                transitionDuration:
                                    Duration.zero, // animasi masuk
                                reverseTransitionDuration:
                                    Duration.zero, // animasi keluar
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFC93C),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "EDIT",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Selesai card profil
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Fungsi pembantu untuk membuat TableRow dengan 3 kolom
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
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  // Fungsi pembantu untuk membuat spacer antar baris
  static TableRow _buildSpacerRow() {
    return const TableRow(
      children: [SizedBox(height: 25), SizedBox(), SizedBox()],
    );
  }
}
