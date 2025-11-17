import 'package:flutter/material.dart';

class GaskuPage extends StatefulWidget {
  const GaskuPage({super.key});

  @override
  State<GaskuPage> createState() => _GaskuPageState();
}

class _GaskuPageState extends State<GaskuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Gasku") ,
         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body:  Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 40),

              // *********************** //
              //         HEADER          //
              // *********************** //
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.home, color: Colors.white, size: 28),

                      Row(
                        children: [
                          Image.asset(
                            "assets/gaslogo.png",
                            width: 30,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "GASKU",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const Icon(Icons.person, color: Colors.white, size: 28),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // *********************** //
              //        MENU CARD        //
              // *********************** //

              _buildMenuButton(
                icon: Icons.propane_tank_outlined,
                title: "Stok Gas",
                onTap: () {},
              ),

              const SizedBox(height: 20),

              _buildMenuButton(
                icon: Icons.shopping_cart_outlined,
                title: "Pembelian",
                onTap: () {},
              ),

              const SizedBox(height: 20),

              _buildMenuButton(
                icon: Icons.history,
                title: "Histori Pembelian",
                onTap: () {},
              ),

              const Spacer(),

              // *********************** //
              //         FOOTER          //
              // *********************** //
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "©2025 Copyright: GasKu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
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
              )
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
}