import 'package:flutter/material.dart';
import '../../../ui/widgets/appbar_2.dart';
import 'package:go_router/go_router.dart';

class PembayaranBerhasilPage extends StatelessWidget {
  const PembayaranBerhasilPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna biru gelap sesuai brand "BIX Cinema"
    const Color primaryBlue = Color(0xFF0D3685);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BixAppBar.logo(),
      body: SafeArea(
        child: Column(
          children: [

            const Spacer(flex: 2),
            // Icon Berhasil
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF74C053),
              child: Icon(
                Icons.check,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Teks Status
            const Text(
              'Pembayaran Berhasil !',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Deskripsi
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Pembayaran kamu sudah kami terima. Tiket/produk kamu lagi diproses ya, cek detailnya di pesanan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),

            const Spacer(flex: 2),

            // Tombol Aksi
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Tombol Detail Pesanan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => context.go('/booking'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Detail Pesanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),

                  // Tombol Kembali
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () => context.go('/home'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.black87),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Kembali Ke Halaman Utama',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}