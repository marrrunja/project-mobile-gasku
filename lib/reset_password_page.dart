import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final newPassController = TextEditingController();

  ResetPasswordPage({super.key});

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
              const Text("Password Baru",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,)),
              const SizedBox(height: 10),
              const Text("Kode OTP berhasil. Silahkan masukkan password baru.",
                  textAlign: TextAlign.center),

              const SizedBox(height: 20),
              TextField(
                controller: newPassController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Masukkan Password Baru",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 45)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Kirim",
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
