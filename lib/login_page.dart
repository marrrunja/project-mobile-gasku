// login_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_gasku/pages/user/beranda.dart';
import 'package:project_gasku/providers/user.dart';
import 'dart:convert';
import 'forgot_password_page.dart';
import 'login_failed_page.dart';
 // UserProvider Anda
// Pastikan UserModel juga sudah diimpor jika diperlukan di sini

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final String _apiUrl = 'http://127.0.0.1:8000/api/login'; 

  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final idMember = idController.text;
    final password = passController.text;

    if (idMember.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Id member atau password tidak boleh kosong!!")),
      );
      return; 
    }

    // Tampilkan pesan proses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Mencoba login...")),
    );

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': idMember, // Diasumsikan API Laravel menggunakan key 'username'
          'password': password,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
      
        final authToken = responseData['token'] as String;
        final userName = responseData['username'] as String;
        
        // Jika API Anda mengembalikan field ini, ganti '1' dengan responseData['jenis_user']
        final jenisUserDefault = responseData['jenis_user'] as int; 

        // ===============================================
        // PENGGUNAAN NOTIFIER PROVIDER UNTUK UPDATE STATE
        // ===============================================
        ref.read(UserProvider.notifier).updateAll( // Panggil Notifier dan method updateAll
          username: userName,
          token: authToken,
          jenisUser: jenisUserDefault, // Gunakan nilai default atau dari API
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil login"),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigasi ke Dashboard (Beranda)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const GaskuPage(), 
          ),
        );
        
      } else if (response.statusCode == 401 || response.statusCode == 422) {
        // Gagal Otentikasi atau Validasi
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login Gagal: ID Member atau Password salah."),
            backgroundColor: Colors.red,
          ),
        );
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginFailedPage(),
          ),
        );
        
      } else {
        // Error server lainnya
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal terhubung ke server. Kode: ${response.statusCode}"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      // Error koneksi
      if (!mounted) return; 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error Koneksi: $e. Pastikan server Laravel berjalan."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
      // ... (Sisa UI Anda tetap sama)
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: _login,
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
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