import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  // Flag untuk berpindah antara langkah 1 dan langkah 2
  bool isStepOne = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubah Password',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 24),
            
            // Logika untuk menampilkan langkah 1 atau langkah 2
            isStepOne ? _buildStepOne() : _buildStepTwo(),
            
            const SizedBox(height: 32),
            
            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isStepOne) {
                      isStepOne = false; // Pindah ke langkah 2
                    } else {
                      // Logika submit password baru di sini
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D3685), // Warna biru gelap sesuai gambar
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk Tampilan Langkah 1 (Password Awal)
  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Masukkan Pasword Awal ',
            style: TextStyle(color: Colors.black, fontSize: 14),
            children: [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField('Masukkan Password'),
      ],
    );
  }

  // Widget untuk Tampilan Langkah 2 (Password Baru & Confirm)
  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Password ',
            style: TextStyle(color: Colors.black, fontSize: 14),
            children: [
              TextSpan(text: '*', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField('Masukkan Password'),
        const SizedBox(height: 12),
        
        // Daftar Syarat Password
        _buildRequirementItem('Password harus mengandung angka'),
        _buildRequirementItem('Minimal 6 karakter'),
        _buildRequirementItem('Pastikan password mengandung huruf'),
        
        const SizedBox(height: 24),
        const Text(
          'Confirm Password',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
        const SizedBox(height: 8),
        _buildTextField('Konfirmasi Password'),
      ],
    );
  }

  // Helper Widget untuk TextField
  Widget _buildTextField(String hint) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  // Helper Widget untuk Baris Persyaratan (Bullet Point)
  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 8, left: 4),
            child: Icon(Icons.circle, size: 4, color: Colors.black),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}