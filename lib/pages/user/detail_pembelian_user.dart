import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '/widgets/base_layout.dart';
import '../../providers/detail_pembayaran.dart'; // Import provider
import 'pembelian_user.dart';

// Ubah menjadi ConsumerWidget
class DetailPembelianUserPage extends ConsumerWidget {
  const DetailPembelianUserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil data transaksi dari Provider
    final transaksi = ref.watch(DetailPembelianProvider);

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
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "DETAIL PEMBAYARAN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Menampilkan Data Dinamis dari Provider
                        _row("Tanggal", transaksi.tanggalFormatted), 
                        const SizedBox(height: 10),
                        _row("Status", transaksi.status, color: Colors.orange),
                        const SizedBox(height: 10),
                        
                        const Divider(),
                        const SizedBox(height: 10),
                        
                        _row("Jumlah Pembelian", "${transaksi.jumlahPembelian} Tabung"),
                        const SizedBox(height: 10),
                        _row("Total Tagihan", "Rp ${transaksi.totalHarga}", isBold: true, fontSize: 16),

                        const SizedBox(height: 25),

                        // Tombol Action
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          const PembelianUserPage(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_back),
                                label: const Text("Kembali"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF63A751).withOpacity(0.7),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Tombol Bayar (WhatsApp) Dinamis
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final phone = "+6282255301884"; // Ganti nomor admin
                                  final message = Uri.encodeComponent(
                                    "Halo Admin, saya ingin konfirmasi pembayaran gas.\n"
                                    "Tanggal: ${transaksi.tanggalFormatted}\n"
                                    "Jumlah: ${transaksi.jumlahPembelian}\n"
                                    "Total: Rp ${transaksi.totalHarga}"
                                  );
                                  final url = "https://wa.me/$phone?text=$message";

                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(
                                      Uri.parse(url),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Gagal membuka WhatsApp"))
                                    );
                                  }
                                },
                                icon: const Icon(Icons.payment),
                                label: const Text("Konfirmasi WA"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF63A751).withOpacity(0.7),
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

  Widget _row(String left, String right, {bool isBold = false, Color? color, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}