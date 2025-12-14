import 'package:flutter/material.dart';
import 'package:project_gasku/login_page.dart';

enum MenuOptions { profile, logout }
class GaskuPage extends StatefulWidget {
  const GaskuPage({super.key});

  @override
  State<GaskuPage> createState() => _GaskuPageState();
}

class _GaskuPageState extends State<GaskuPage> {
  // Opsi untuk PopUpMenuButton
  // Nilai ini akan digunakan untuk mengidentifikasi item mana yang diklik

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(73, 155, 91, 0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // KIRI: Icon Home
            const Row(children: [
              Icon(Icons.home_filled, color: Colors.white, size: 38.0)
            ]),

            // TENGAH: Judul
            const Text(
              "GASKU",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                letterSpacing: 2.5,
              ),
            ),

            // KANAN: PopUpMenuButton (Menggantikan Icon biasa)
            // Ini akan menampilkan dropdown
            PopupMenuButton<MenuOptions>(
              // Ikon yang akan ditampilkan sebelum dropdown muncul
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 40.0,
              ),
              // Fungsi yang dipanggil ketika salah satu item dipilih
              onSelected: (MenuOptions result) {
                switch (result) {
                  case MenuOptions.profile:
                    // TODO: Tambahkan navigasi ke halaman Profil
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profil diklik!')),
                    );
                    break;
                  case MenuOptions.logout:
                    // TODO: Tambahkan logika Logout/Keluar
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    break;
                }
              },
              // Membangun daftar item dropdown
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<MenuOptions>>[
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.profile,
                  child: Row(
                    children: [
                      Icon(Icons.person, color: Colors.black54),
                      SizedBox(width: 8),
                      Text('Profil'),
                    ],
                  ),
                ),
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.logout,
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Keluar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // *********************** //
            //      MENU CARD        //
            // *********************** //
            _buildMenuButton(
              icon: Icons.propane_tank_outlined,
              title: "Stok Gas",
              onTap: () {
                // Tambahkan aksi ketika Stok Gas diklik
              },
            ),

            const SizedBox(height: 20),

            _buildMenuButton(
              icon: Icons.shopping_cart_outlined,
              title: "Pembelian",
              onTap: () {
                // Tambahkan aksi ketika Pembelian diklik
              },
            ),

            const SizedBox(height: 20),

            _buildMenuButton(
              icon: Icons.history,
              title: "Histori Pembelian",
              onTap: () {
                // Tambahkan aksi ketika Histori Pembelian diklik
              },
            ),

            const Spacer(),

            // *********************** //
            //         FOOTER          //
            // *********************** //
            Container(
              padding: const EdgeInsets.all(25.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(73, 155, 91, 0.8),
              ),
              child: const Center(
                child: Text(
                  "©2025 Copyright: GasKu",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================== //
  //        MENU BUTTON UI          //
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
            border: Border.all(
              color: const Color.fromRGBO(73, 155, 91, 0.8),
              width: 4,
            ),
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
              Icon(icon,
                  color: const Color.fromRGBO(73, 155, 91, 0.8), size: 35),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(73, 155, 91, 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}