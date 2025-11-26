import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/widgets/base_layout.dart';
import 'profil_view_user.dart';

class ProfilEditUserPage extends StatefulWidget {
  const ProfilEditUserPage({super.key});

  @override
  State<ProfilEditUserPage> createState() => _ProfilEditUserPageState();
}

class _ProfilEditUserPageState extends State<ProfilEditUserPage> {
  File? _avatarImage; // Menyimpan gambar yang dipilih

  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

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
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5FA777),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Avatar sebagai input gambar
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: _avatarImage != null
                              ? FileImage(_avatarImage!)
                              : null,
                          child: _avatarImage == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 35,
                                  color: Color(0xFF5FA777),
                                )
                              : null,
                        ),
                      ),
                      //gtw bener atau engga
                      //nanti permission nya di buat dulu, klo engga, dia ga bisa buka galeri hp hehe
                      const SizedBox(height: 12),

                      // Nama utama
                      const Text(
                        "PEOPLE +62",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // TextField Email
                      buildInputField("ubah@gmail.com"),
                      const SizedBox(height: 10),

                      // TextField KK
                      buildInputField("1122334455667788"),
                      const SizedBox(height: 10),

                      // TextField No Telp
                      buildInputField("0812"),
                      const SizedBox(height: 10),

                      // TextField Alamat
                      buildInputField("Jalanin aja dulu", maxLines: 2),
                      const SizedBox(height: 25),

                      // Tombol Aksi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // BATAL
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) =>
                                        const ProfilViewUserPage(),
                                    transitionDuration:
                                        Duration.zero, // animasi masuk
                                    reverseTransitionDuration:
                                        Duration.zero, // animasi keluar
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF0000),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                "BATAL",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // SIMPAN
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3771C8),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                "SIMPAN",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

  // Widget helper TextField
  static Widget buildInputField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
