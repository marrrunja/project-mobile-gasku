import 'package:flutter/material.dart';
import 'reset_password_page.dart';

class OtpPage extends StatelessWidget {
  OtpPage({super.key});

  final otpController = List.generate(6, (index) => TextEditingController());

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
              const Text("Local Host Say",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green,)),
              const SizedBox(height: 10),
              const Text(
                "Masukkan kode OTP yang telah kami kirim ke email anda",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 40,
                    child: TextField(
                      controller: otpController[index],
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(counterText: ""),
                    ),
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
                    MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                  );
                },
                child: const Text(
                  "Kirim",
                  style: TextStyle(color: Colors.white)
                  ),
              ),

              const SizedBox(height: 10),
              const Text("Kirim ulang kode OTP")
            ],
          ),
        ),
      ),
    );
  }
}
