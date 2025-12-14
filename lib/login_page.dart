// login_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- Import Riverpod
import 'package:project_gasku/pages/user/beranda.dart';
import 'package:project_gasku/providers/user.dart';
import 'dart:convert';
import 'forgot_password_page.dart';
import 'login_failed_page.dart';
// Asumsikan path ini benar

// ===========================================
// UBAH DARI StatefulWidget MENJADI ConsumerStatefulWidget
// ===========================================
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

// =BAIKAN: _LoginPageState sekarang turunan dari ConsumerState=
class _LoginPageState extends ConsumerState<LoginPage> {
  // 1. Definisikan Controllers
  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  // URL API: Diubah ke 10.0.2.2 agar kompatibel dengan Android Emulator
  final String _apiUrl = 'http://localhost:8000/api/login';

  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }

  // 2. Fungsi Asinkronus untuk Login
  Future<void> _login() async {
    final idMember = idController.text;
    final password = passController.text;

    if (idMember.isEmpty || password.isEmpty) {
      // Menggunakan .isEmpty lebih disarankan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan password tidak boleh kosong"),
        ),
      );
      return; // Hentikan fungsi jika validasi gagal
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Mencoba login...")));

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': idMember,
          'password': password,
        }),
      );

      // Pastikan context masih valid sebelum navigasi/menampilkan SnackBar
      if (!mounted) return;

      if (response.statusCode == 200) {
        // Login BERHASIL
        final responseData = jsonDecode(response.body);

        final authToken = responseData['token'] as String;
        final userName = responseData['username'] as String;
        // API Anda tidak mengembalikan jenisUser, kita asumsikan default atau ambil dari data lain
        const jenisUserDefault = 1;
        final canBuy = responseData['can_buy'] as int;

        // =======================================================
        // AKSI PENTING: SIMPAN DATA KE USER MODEL MENGGUNAKAN RIVERPOD
        // =======================================================
        ref
            .read(UserProvider.notifier)
            .updateAll(
              username: userName,
              token: authToken,
              jenisUser: jenisUserDefault,
              canBuy:canBuy
            );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil login"),
            backgroundColor: Colors.green,
          ),
        );

        // Navigasi ke Dashboard dan hapus semua halaman sebelumnya (pushReplacement)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GaskuPage(), // Arahkan ke dashboard
          ),
        );
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        // Gagal Otentikasi (401 Unauthorized) atau Validasi (422 Unprocessable Entity)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Gagal: ID Member atau Password salah."),
            backgroundColor: Colors.red,
          ),
        );

        // Navigasi ke halaman Gagal Login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginFailedPage()),
        );
      } else {
        // Error server lainnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gagal terhubung ke server. Kode: ${response.statusCode}",
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Error koneksi (timeout, server mati, dll.)
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error Koneksi: $e. Pastikan server Laravel berjalan."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> updateUser({
    required String token,
    required String username,
    required String namaLengkap,
    required String email,
    required String alamat,
    required String noKk,
  }) async {
    const apiUrl = 'http://localhost:8000/api/profil/ubah'; // ganti sesuai endpoint API

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'nama_lengkap': namaLengkap,
          'email': email,
          'alamat': alamat,
          'no_kk': noKk,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == "Berhasil update data user") {
          return true;
        } else {
          // pesan lain dari API
          print(data['message']);
          return false;
        }
      } else {
        print('Status code error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error update user: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tidak ada perubahan di bagian build, hanya menggunakan ConsumerState
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 330,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "LOGIN FORM",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              // TextField ID Member
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  hintText: "ID Member",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // TextField Password
              TextField(
                controller: passController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              // Lupa Password?
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage(),
                    ),
                  );
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Tombol Login
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: _login, // Panggil fungsi _login()
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Register Sekarang
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: "Poppins",
                  ),
                  children: [
                    TextSpan(text: "Bukan Member? "),
                    TextSpan(
                      text: "Register Sekarang",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
