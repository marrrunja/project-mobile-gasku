import 'package:flutter/material.dart';
import '/widgets/base_layout.dart';
import 'package:url_launcher/url_launcher.dart';
import 'pembelian_user.dart';

class DetailPembelianUserPage extends StatelessWidget {
  const DetailPembelianUserPage({super.key});

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
                // mulai content: Detail Card
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.90,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "PEMBAYARAN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _row("Harga Satuan", "Rp 28.000"),
                        const SizedBox(height: 10),
                        _row("Biaya Admin", "Rp 2.500"),
                        const SizedBox(height: 10),
                        _row("Metode Pembayaran", "BRI TRANSFER"),
                        const SizedBox(height: 10),
                        _row("Jumlah Pembelian", "1"),

                        const SizedBox(height: 10),
                        const Divider(),

                        const SizedBox(height: 10),
                        _row("Total", "Rp 30.500", isBold: true),

                        const SizedBox(height: 25),

                        //button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
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
                                  backgroundColor: Color(
                                    0xFF63A751,
                                  ).withOpacity(0.7),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            //Button Bayar (WhatsApp)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final phone = "+6282255301884";
                                  final message = Uri.encodeComponent(
                                    "Halo, saya ingin membayar gas ",
                                  );
                                  final url =
                                      "https://wa.me/$phone?text=$message";

                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(
                                      Uri.parse(url),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    debugPrint("Tidak bisa membuka WhatsApp");
                                  }
                                },
                                icon: const Icon(Icons.payment),
                                label: const Text("Bayar Rp 30.000"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                    0xFF63A751,
                                  ).withOpacity(0.7),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
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
                // selesai content
              ],
            ),
          ),
        ),
      ),
    );
  }

  _row(String left, String right, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          left,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          right,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
