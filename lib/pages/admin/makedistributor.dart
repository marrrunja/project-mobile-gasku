import 'package:flutter/material.dart';

class RegisterDistributorPage extends StatelessWidget {
  const RegisterDistributorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7BA87E), // warna hijau latar belakang
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8E7), // warna putih kekuningan
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'REGISTER FORM',
                    style: TextStyle(
                      color: Color(0xFF3D7A3D),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama depan & nama belakang
                  Row(
                    children: [
                      Expanded(child: _buildInputField('Nama Depan')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildInputField('Nama Belakang')),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildInputField('Nomor Kartu Keluarga'),
                  const SizedBox(height: 10),

                  // Email & no HP
                  Row(
                    children: [
                      Expanded(child: _buildInputField('Email')),
                      const SizedBox(width: 10),
                      Expanded(child: _buildInputField('No. HP')),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildInputField('Alamat'),
                  const SizedBox(height: 10),

                  _buildInputField('Password', isPassword: true),
                  const SizedBox(height: 10),

                  _buildInputField('Ulangi Password', isPassword: true),
                  const SizedBox(height: 10),

                  _buildInputField('Kode Distributor = 1'),
                  const SizedBox(height: 20),

                  // Tombol Batal & Buat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade400,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5EA463),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Buat',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
        ),
      ),
    );
  }

  // Widget helper untuk textfield
  static Widget _buildInputField(String label, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF5EA463)),
        ),
        suffixIcon: isPassword
            ? const Icon(Icons.visibility_outlined, color: Colors.grey)
            : null,
      ),
    );
  }
}
