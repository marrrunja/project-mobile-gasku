import 'package:flutter/material.dart';
import '/widgets/base_layout.dart';

class StokGasPage extends StatelessWidget {
  const StokGasPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                // Mulai card profil

                // CARD PENGUMUMAN
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey, // warna frame
                        width: 1.2, // ketebalan garis
                      ),
                    ),
                    child: Column(
                      children: const [
                        Text(
                          "Pengumuman",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF65916F),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Tersedia Tabung Gas di Pangkalan\n200",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF5D7F27),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6),
                        Text(
                          "terakhir di update 29/10/2024",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6EAF7C),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Selesai card profil
              ],
            ),
          ),
        ),
      ),
    );
  }
}
