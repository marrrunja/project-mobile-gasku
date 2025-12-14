// import 'package:flutter/material.dart';
// import '/widgets/base_layout.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'pembelian_user.dart';

// class DetailTransaksiUserPage extends StatelessWidget {
//   const DetailTransaksiUserPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BaseLayout(
//       child: SingleChildScrollView(
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minHeight: MediaQuery.of(context).size.height - 260,
//           ),
//           child: Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // mulai content: Detail Card
//                 Center(
//                   child: Container(
//                     width: MediaQuery.of(context).size.width * 0.90,
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(2),
//                       border: Border.all(
//                         color: const Color(0xFF3771C8), // warna border baru
//                         width: 2,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Center(
//                           child: Text(
//                             "Detail",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),

//                         // Tabel row 3 kolom
//                         buildTableRow("Tgl Transaksi", "28 AGUSTUS 2024"),
//                         buildTableRow("Produk", "GAS LPG 3 KG"),
//                         buildTableRow("Kuantitas", "1"),
//                         buildTableRow("Status", "Belum bayar"),
//                         buildTableRow("Total", "30.000"),

//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: ElevatedButton.icon(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     PageRouteBuilder(
//                                       pageBuilder: (_, __, ___) =>
//                                           const PembelianUserPage(),
//                                       transitionDuration: Duration.zero,
//                                       reverseTransitionDuration: Duration.zero,
//                                     ),
//                                   );
//                                 },
//                                 icon: const Icon(Icons.arrow_back),
//                                 label: const Text("Kembali"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color(0xFF63A751).withOpacity(0.7),
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 12,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
                            
//                             //Button Bayar (WhatsApp)
//                             Expanded(
//                               child: ElevatedButton.icon(
//                                 onPressed: () async {
//                                   final phone = "+6282255301884";
//                                   final message = Uri.encodeComponent(
//                                       "Halo, saya ingin membayar gas");
//                                   final url = "https://wa.me/$phone?text=$message";

//                                   if (await canLaunchUrl(Uri.parse(url))) {
//                                     await launchUrl(Uri.parse(url),
//                                         mode: LaunchMode.externalApplication);
//                                   } else {
//                                     debugPrint("Tidak bisa membuka WhatsApp");
//                                   }
//                                 },
//                                 icon: const Icon(Icons.payment),
//                                 label: const Text("Bayar"),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Color(
//                                     0xFF63A751,
//                                   ).withOpacity(0.7),
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(vertical: 12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(6),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // selesai content
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// Tabel row 3 kolom: Judul | : | Value
//   Widget buildTableRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               label,
//               style: const TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           const Text(": "), // titik dua
//           Expanded(flex: 5, child: Text(value)),
//         ],
//       ),
//     );
//   }
// }

