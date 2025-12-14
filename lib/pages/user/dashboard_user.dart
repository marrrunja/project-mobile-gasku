import 'package:flutter/material.dart';
import '/widgets/base_layout.dart';
import 'stok_gas.dart';
import 'pembelian_user.dart';
import 'histori_pembelian_user.dart';

class DashboardUserPage extends StatelessWidget {
  const DashboardUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                260, //ini penting klo mau buat isian ke tengah, soal nya di layout header aku pake save zone biar ga nabrak bar hp
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // mulai content
                _buildMenuButton(
                  icon: Icons.propane_tank_outlined,
                  title: "Stok Gas",
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const StokGasPage(),
                        transitionDuration: Duration.zero, // animasi masuk
                        reverseTransitionDuration:
                            Duration.zero, // animasi keluar
                      ),
                    );
                  },
                ),
                const SizedBox(height: 45),

                _buildMenuButton(
                  icon: Icons.shopping_cart_outlined,
                  title: "Pembelian",
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const PembelianUserPage(),
                        transitionDuration: Duration.zero, // animasi masuk
                        reverseTransitionDuration:
                            Duration.zero, // animasi keluar
                      ),
                    );
                  },
                ),
                const SizedBox(height: 45),

                _buildMenuButton(
                  icon: Icons.history,
                  title: "Histori Pembelian",
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HistoriPembelianPage(),
                        transitionDuration: Duration.zero, // animasi masuk
                        reverseTransitionDuration:
                            Duration.zero, // animasi keluar
                      ),
                    );
                  },
                ),
                //selesai content
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================== //
//         MENU BUTTON UI         //
// ============================== //
Widget _buildMenuButton({
  required IconData icon,
  required String title,
  required Function() onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.green, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green, size: 35),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
