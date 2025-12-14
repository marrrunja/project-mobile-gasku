import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '/widgets/base_layout.dart';
import '../../providers/user.dart';
import 'profil_view_user.dart';

class ProfilEditUserPage extends ConsumerStatefulWidget {
  const ProfilEditUserPage({super.key});

  @override
  ConsumerState<ProfilEditUserPage> createState() => _ProfilEditUserPageState();
}

class _ProfilEditUserPageState extends ConsumerState<ProfilEditUserPage> {
  File? _avatarImage;
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController noKkController = TextEditingController();

  bool _isUserLoaded = false; // tanda sudah set controller

  @override
  void dispose() {
    usernameController.dispose();
    namaController.dispose();
    emailController.dispose();
    alamatController.dispose();
    noKkController.dispose();
    super.dispose();
  }

  // Fungsi ambil gambar
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _avatarImage = File(pickedFile.path));
    }
  }

  // Ambil data user
  Future<Map<String, dynamic>> getUser(String token) async {
    const apiUrl = 'http://localhost:8000/api/me';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) throw Exception('Gagal mengambil data user');
    return jsonDecode(response.body)['user'];
  }

  // Update user
  Future<bool> updateUser({
    required String token,
    required String username,
    required String namaLengkap,
    required String email,
    required String alamat,
    required String noKk,
  }) async {
    const apiUrl = 'http://localhost:8000/api/profil/ubah';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'nama_lengkap': namaLengkap,
          'email': email,
          'alamat': alamat,
          'no_kk': noKk,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] == "Berhasil update data user";
      }
      return false;
    } catch (e) {
      print('Error update user: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(UserProvider);

    return BaseLayout(
      child: FutureBuilder<Map<String, dynamic>>(
        future: getUser(authUser.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final user = snapshot.data!;

          // Set controller hanya sekali
          if (!_isUserLoaded) {
            usernameController.text = user['username'] ?? '';
            namaController.text = user['nama_lengkap'] ?? '';
            emailController.text = user['email'] ?? '';
            alamatController.text = user['alamat_lengkap'] ?? '';
            noKkController.text = user['no_kk'] ?? '';
            _isUserLoaded = true;
          }

          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 260,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5FA777),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: _avatarImage != null
                                  ? FileImage(_avatarImage!)
                                  : (user['foto'] != null
                                      ? NetworkImage(
                                          'http://localhost:8000/storage/${user['foto']}',
                                        )
                                      : null),
                              child: _avatarImage == null && user['foto'] == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 35,
                                      color: Color(0xFF5FA777),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          buildInputField("Username", controller: usernameController),
                          const SizedBox(height: 10),
                          buildInputField("Nama Lengkap", controller: namaController),
                          const SizedBox(height: 10),
                          buildInputField("Email", controller: emailController),
                          const SizedBox(height: 10),
                          buildInputField("Alamat", controller: alamatController, maxLines: 2),
                          const SizedBox(height: 10),
                          buildInputField("No. KK", controller: noKkController),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ProfilViewUserPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF0000),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final success = await updateUser(
                                      token: authUser.token,
                                      username: usernameController.text,
                                      namaLengkap: namaController.text,
                                      email: emailController.text,
                                      alamat: alamatController.text,
                                      noKk: noKkController.text,
                                    );

                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          success
                                              ? 'Berhasil update user'
                                              : 'Gagal update user',
                                        ),
                                        backgroundColor: success ? Colors.green : Colors.red,
                                      ),
                                    );

                                    if (success) Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3771C8),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget buildInputField(
    String hint, {
    TextEditingController? controller,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
