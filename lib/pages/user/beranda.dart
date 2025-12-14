import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_gasku/login_page.dart';
import 'package:project_gasku/pages/user/histori_pembelian_user.dart';
import 'package:project_gasku/pages/user/pembelian_user.dart';
import 'package:project_gasku/pages/user/profil_view_user.dart';
import 'package:project_gasku/pages/user/stok_gas.dart';
import 'package:project_gasku/providers/user.dart';

enum MenuOptions { profile, logout }

class GaskuPage extends ConsumerStatefulWidget {
  const GaskuPage({super.key});

  @override
  ConsumerState<GaskuPage> createState() => _GaskuPageState();
}

class _GaskuPageState extends ConsumerState<GaskuPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(UserProvider);
    final canBuy = user.canBuy.toString();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(73, 155, 91, 0.8),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // KIRI
            const Icon(Icons.home_filled, color: Colors.white, size: 38.0),

            // TENGAH
            const Text(
              "GASKU",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                letterSpacing: 2.5,
              ),
            ),

            // KANAN
            PopupMenuButton<MenuOptions>(
              icon: const Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 40.0,
              ),
              onSelected: (MenuOptions result) {
                switch (result) {
                  case MenuOptions.profile:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilViewUserPage(),
                      ),
                    );
                    break;

                  case MenuOptions.logout:
                    // NANTI BISA TAMBAH:
                    // ref.read(UserProvider.notifier).logout();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) =>
                  const <PopupMenuEntry<MenuOptions>>[
                    PopupMenuItem<MenuOptions>(
                      value: MenuOptions.profile,
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.black54),
                          SizedBox(width: 8),
                          Text('Profil'),
                        ],
                      ),
                    ),
                    PopupMenuItem<MenuOptions>(
                      value: MenuOptions.logout,
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Keluar', style: TextStyle(color: Colors.red)),
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

            _buildMenuButton(
              icon: Icons.propane_tank_outlined,
              title: "Stok Gas",
              onTap: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StokGasPage()),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildMenuButton(
              icon: Icons.shopping_cart_outlined,
              title: "Pembelian",
              onTap: () {
                if (user.canBuy == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Anda belum menyelesaikan transaksi sebelumnya!"),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PembelianUserPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            _buildMenuButton(
              icon: Icons.history,
              title: "Histori Pembelian",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoriPembelianPage(),
                  ),
                );
              },
            ),

            const Spacer(),

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
    required VoidCallback onTap,
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
              Icon(
                icon,
                color: const Color.fromRGBO(73, 155, 91, 0.8),
                size: 35,
              ),
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
