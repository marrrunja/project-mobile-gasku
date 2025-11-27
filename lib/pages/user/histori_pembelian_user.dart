import 'package:flutter/material.dart';
import '/widgets/base_layout_no_secroll.dart';

import 'detail_transaksi_user.dart';

class HistoriPembelianPage extends StatelessWidget {
  const HistoriPembelianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayoutNS(
      child: Column(
        children: [
          // ======================
          // Bagian Judul + Dropdown
          // ======================
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "SILAHKAN LIHAT DETAIL UNTUK\nMEMERIKSA RIWAYAT TRANSAKSI ANDA",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          // Dropdown filter
          Padding(
            padding: const EdgeInsets.only(right:180),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black38),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  // isExpanded: true,
                  value: "All",
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All")),
                    DropdownMenuItem(value: "2024", child: Text("2024")),
                    DropdownMenuItem(value: "2023", child: Text("2023")),
                  ],
                  onChanged: (value) {
                    // TODO: Handle filter
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ======================
          // Bagian List Card
          // ======================
          // Expanded + ListView supaya hanya daftar card yang bisa digulir
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20),
              children: [
                buildHistoryItem(context, "12 November 2024"),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================
// Widget card item riwayat
// ======================
Widget buildHistoryItem(BuildContext context, String date) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: Colors.black12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tanggal
        Text(
          date,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),

        // Tombol Lihat Detail → bisa diklik
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const DetailTransaksiUserPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child: Row(
            children: const [
              Text(
                "Lihat detail",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.info_outline, color: Colors.green, size: 18),
            ],
          ),
        ),
      ],
    ),
  );
}
