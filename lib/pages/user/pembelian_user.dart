import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '/widgets/base_layout.dart';
import '../../providers/user.dart';
import '../../providers/detail_pembayaran.dart';
import 'dashboard_user.dart';
import 'detail_pembelian_user.dart';

class PembelianUserPage extends ConsumerStatefulWidget {
  const PembelianUserPage({super.key});

  @override
  ConsumerState<PembelianUserPage> createState() => _PembelianUserPageState();
}

class _PembelianUserPageState extends ConsumerState<PembelianUserPage> {
  final TextEditingController _jumlahController = TextEditingController();
  
  // State loading
  bool _isLoading = false;
  
  // URL API (Sesuaikan dengan env lokal Anda)
  static const String _baseUrl = 'http://localhost:8000/api'; 
  static const String _pembelianEndpoint = '$_baseUrl/gas/pembelian';

  @override
  void dispose() {
    _jumlahController.dispose();
    super.dispose();
  }

  // --- LOGIC API ---
  Future<Map<String, dynamic>> pesanGas({
    required String token,
    required int jumlah,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_pembelianEndpoint),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'jumlah': jumlah}),
      );
      
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true, 
          'message': responseBody['message'],
          'data': responseBody, 
        };
      } else {
        String errorMessage = 'Terjadi kesalahan pada server.';
        if (response.statusCode == 422 && responseBody['errors'] != null) {
          errorMessage = responseBody['errors']['jumlah']?[0] ?? 'Input tidak valid.';
        } else {
          errorMessage = responseBody['error'] ?? responseBody['message'] ?? errorMessage;
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server: $e'};
    }
  }

  // --- LOGIC DIALOG & REDIRECT ---
  void _showResultDialog(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop(); 
              
              if (isSuccess) {
                // Redirect ke halaman detail jika sukses
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const DetailPembelianUserPage(),
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

  // --- LOGIC TOMBOL PESAN (Dengan Safe Parsing) ---
  void _handlePesan() async {
    final authUser = ref.read(UserProvider);
    final jumlahText = _jumlahController.text.trim();
    final jumlah = int.tryParse(jumlahText);

    if (jumlah == null || jumlah <= 0) {
      _showResultDialog('Error Input', 'Masukkan jumlah gas yang valid.');
      return;
    }
    
    setState(() => _isLoading = true);
    
    final result = await pesanGas(
      token: authUser.token,
      jumlah: jumlah,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);
    
    if (result['success']) {
      final data = result['data'];
      
      // Safe Parsing: Pastikan tidak error jika null/string
      final int jumlahFix = int.tryParse('${data['jumlah']}') ?? 0;
      final int totalFix = int.tryParse('${data['total']}') ?? 0;
      final String tglFix = data['tanggal_transaksi']?.toString() ?? '-';

      // Update Provider
      ref.read(DetailPembelianProvider.notifier).setTransaksiBaru(
        jumlah: jumlahFix,
        total: totalFix,
        tanggalString: tglFix,
      );

      _showResultDialog('Pemesanan Berhasil', result['message'], isSuccess: true);
    } else {
      _showResultDialog('Pemesanan Gagal', result['message']);
    }
  }

  // --- UI ORIGINAL ---
  @override
  Widget build(BuildContext context) {
    // Ambil data user untuk logic UI (limit pembelian)
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
                
                // Input Field Style Original
                Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6BB57A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
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
                ),

                const SizedBox(height: 25),

                // Tombol Pesan Sekarang
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handlePesan, // Panggil fungsi logic baru
                    icon: _isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                        : const Icon(Icons.shopping_cart),
                    label: Text(_isLoading ? "Memproses..." : "Pesan Sekarang!"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5FA777),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
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
                    label: const Text("Kembali"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5FA777),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Bagian Perhatian (UI Original dikembalikan)
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
                      const Text(
                        "Setiap warga hanya diperbolehkan membeli 1 tabung gas LPG pada setiap kali kedatangan. "
                        "Sementara itu, pemilik toko atau distributor diperbolehkan membeli hingga maksimal 10 "
                        "tabung gas LPG pada setiap kali kedatangan.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
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