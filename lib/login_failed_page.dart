import 'package:flutter/material.dart';

class LoginFailedPage extends StatelessWidget {
  const LoginFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                "Login Gagal",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,),
              ),
              const SizedBox(height: 10),
              const Text(
                "Username atau password anda tidak cocok. Silahkan masukkan username dan password anda.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  Navigator.pop(context); // kembali ke login
                },
                child: const Text(
                  "Login Ulang",
                  style: TextStyle(color: Colors.white),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
