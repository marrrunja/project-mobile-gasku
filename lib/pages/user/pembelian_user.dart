import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '/widgets/base_layout.dart';
import '../../providers/user.dart';
import 'dashboard_user.dart';
import 'detail_transaksi_user.dart';

class PembelianUserPage extends ConsumerStatefulWidget {
  const PembelianUserPage({super.key});

  @override
  ConsumerState<PembelianUserPage> createState() => _PembelianUserPageState();
}

class _PembelianUserPageState extends ConsumerState<PembelianUserPage> {
  final TextEditingController _jumlahController = TextEditingController();
  
  // State untuk melacak status loading saat memproses pemesanan
  bool _isLoading = false; 
  
  // Ganti dengan base URL Laravel Anda
  static const String _baseUrl = 'http://localhost:8000/api'; 
  static const String _pembelianEndpoint = '$_baseUrl/gas/pembelian';

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  // --- FUNGSI PEMANGGILAN API UNTUK PEMESANAN GAS (DIGABUNGKAN) ---
  Future<Map<String, dynamic>> pesanGas({
    required String token,
    required int jumlah,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_pembelianEndpoint),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Menggunakan Token Sanctum
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'jumlah': jumlah, // Key 'jumlah' sesuai yang divalidasi di Laravel
        }),
      );
      
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true, 
          'message': responseBody['message'] ?? 'Berhasil melakukan pemesanan gas.'
        };
      } else {
        // Penanganan error dari Laravel (termasuk 422 Validasi dan error logic)
        String errorMessage = 'Terjadi kesalahan pada server.';
        
        if (response.statusCode == 422 && responseBody['errors'] != null) {
          // Error Validasi (misal: jumlah melebihi batas)
          errorMessage = responseBody['errors']['jumlah']?[0] ?? 'Input jumlah tidak valid.';
        } else {
          // Error logic dari controller (misal: 'Saat ini anda tidak boleh melakukan pembelian!')
          errorMessage = responseBody['error'] ?? responseBody['message'] ?? errorMessage;
        }

        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('Error pemesanan gas: $e');
      return {'success': false, 'message': 'Gagal terhubung ke server: Pastikan API berjalan.'};
    }
  }
  // -------------------------------------------------------------------

  // Fungsi untuk menampilkan dialog hasil
  void _showResultDialog(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
              if (isSuccess) {
                // Navigasi ke halaman detail transaksi jika sukses
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const DetailTransaksiUserPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Fungsi utama untuk menangani pemesanan
  void _handlePesan() async {
    final authUser = ref.read(UserProvider);
    final jumlahText = _jumlahController.text.trim();
    final jumlah = int.tryParse(jumlahText);

    if (jumlah == null || jumlah <= 0) {
      _showResultDialog('Error Input', 'Masukkan jumlah gas yang valid (angka lebih dari 0).');
      return;
    }
    
    // Tampilkan loading
    setState(() => _isLoading = true);
    
    // Panggil fungsi API yang sudah digabungkan
    final result = await pesanGas(
      token: authUser.token,
      jumlah: jumlah,
    );

    // Hilangkan loading
    if (!mounted) return;
    setState(() => _isLoading = false);
    
    // Tampilkan hasil
    if (result['success']) {
      _showResultDialog('Pemesanan Berhasil', result['message'], isSuccess: true);
    } else {
      _showResultDialog('Pemesanan Gagal', result['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(UserProvider);
    final maxPembelian = user.jenisUser == 1 ? 10 : 1; 

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
                const SizedBox(height: 20),

                const Text(
                  "Masukkan Jumlah Gas yang ingin dibeli",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF63A751),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 20),

                // Input Field
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6BB57A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black38),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: _jumlahController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "1 - $maxPembelian",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Tombol Pesan Sekarang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handlePesan, 
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(
                              color: Colors.white, 
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.shopping_cart),
                    label: Text(
                      _isLoading ? "Memproses..." : "Pesan Sekarang!",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5FA777),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Tombol Kembali
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) => const DashboardUserPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text(
                      "Kembali",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5FA777),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Container Perhatian (Info Batasan)
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Perhatian",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFF6BB57A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Setiap warga hanya diperbolehkan membeli 1 tabung gas LPG pada setiap kali kedatangan. "
                        "Sementara itu, pemilik toko atau distributor diperbolehkan membeli hingga maksimal 10 "
                        "tabung gas LPG pada setiap kali kedatangan.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5D7F27),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}