import 'package:flutter/material.dart';
import 'otp_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  final emailController = TextEditingController();

  ForgotPasswordPage({super.key});

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
              const Text("Lupa Password?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,)),
              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Masukkan Email",
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtpPage()),
                  );
                },
                child: const Text(
                  "Kirim",
                  style: TextStyle(color: Colors.white),
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
