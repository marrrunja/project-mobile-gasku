import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:project_gasku/providers/user.dart';
import '/widgets/base_layout_no_secroll.dart';
import '/widgets/base_layout.dart';
import 'package:url_launcher/url_launcher.dart';

// ======================
// Model Transaksi
// ======================
class TransaksiModel {
  final int id;
  final int jumlahPembelian;
  final int idGas;
  final int idUser;
  final int status;
  final DateTime createdAt;

  TransaksiModel({
    required this.id,
    required this.jumlahPembelian,
    required this.idGas,
    required this.idUser,
    required this.status,
    required this.createdAt,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['id'],
      jumlahPembelian: json['jumlah_pembelian'],
      idGas: json['id_gas'],
      idUser: json['id_user'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  String get formattedDate => DateFormat('dd MMMM yyyy').format(createdAt);

  String get statusText {
    switch (status) {
      case 0:
        return "Belum Dibayar";
      case 1:
        return "Selesai";
      default:
        return "Menunggu";
    }
  }

  int get totalHarga => jumlahPembelian * 25000; // contoh harga per gas
}

// ======================
// Provider fetch transaksi
// ======================
final transaksiProvider = FutureProvider<List<TransaksiModel>>((ref) async {
  final user = ref.watch(UserProvider);
  final token = user.token;

  final url = Uri.parse('http://localhost:8000/api/transaksi/get/user');

  final response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'] as List;
    return data.map((e) => TransaksiModel.fromJson(e)).toList();
  } else {
    throw Exception('Gagal mengambil data transaksi');
  }
});

// ======================
// Halaman Histori Pembelian
// ======================
class HistoriPembelianPage extends ConsumerWidget {
  const HistoriPembelianPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaksiAsync = ref.watch(transaksiProvider);

    return BaseLayoutNS(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "SILAHKAN LIHAT DETAIL UNTUK\nMEMERIKSA RIWAYAT TRANSAKSI ANDA",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Dropdown filter (sementara static)
          Padding(
            padding: const EdgeInsets.only(right: 180),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.black38),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: "All",
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All")),
                    DropdownMenuItem(value: "2024", child: Text("2024")),
                    DropdownMenuItem(value: "2023", child: Text("2023")),
                  ],
                  onChanged: (value) {},
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: transaksiAsync.when(
              data: (transaksis) {
                if (transaksis.isEmpty) {
                  return const Center(child: Text("Belum ada transaksi"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: transaksis.length,
                  itemBuilder: (context, index) {
                    final t = transaksis[index];
                    return buildHistoryItem(context, t);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================
// Widget card transaksi
// ======================
Widget buildHistoryItem(BuildContext context, TransaksiModel t) {
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
        Text(
          t.formattedDate,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) =>
                    DetailTransaksiUserPage(transaksi: t),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child: Row(
            children: [
              Text(
                t.statusText,
                style: TextStyle(
                  fontSize: 14,
                  color: t.status == 1 ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.info_outline, size: 18),
            ],
          ),
        ),
      ],
    ),
  );
}

// ======================
// Halaman Detail Transaksi
// ======================
class DetailTransaksiUserPage extends StatelessWidget {
  final TransaksiModel transaksi;
  const DetailTransaksiUserPage({super.key, required this.transaksi});

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
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: const Color(0xFF3771C8),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Detail Transaksi",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildTableRow("Tgl Transaksi", transaksi.formattedDate),
                        buildTableRow("Produk", "GAS LPG 3 KG"),
                        buildTableRow(
                            "Kuantitas", transaksi.jumlahPembelian.toString()),
                        buildTableRow("Status", transaksi.statusText),
                        buildTableRow("Total", "Rp ${transaksi.totalHarga}"),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back),
                                label: const Text("Kembali"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF63A751).withOpacity(0.7),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final phone = "+6282255301884";
                                  final message = Uri.encodeComponent(
                                      "Halo, saya ingin membayar gas");
                                  final url = "https://wa.me/$phone?text=$message";

                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url),
                                        mode: LaunchMode.externalApplication);
                                  } else {
                                    debugPrint("Tidak bisa membuka WhatsApp");
                                  }
                                },
                                icon: const Icon(Icons.payment),
                                label: const Text("Bayar"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF63A751).withOpacity(0.7),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          const Text(": "),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
