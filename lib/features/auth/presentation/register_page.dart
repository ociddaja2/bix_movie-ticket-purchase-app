import 'package:flutter/material.dart';
import 'package:bixcinema/ui/widgets/backgroundLoginWidget.dart';
import 'package:bixcinema/ui/widgets/logoBoxWidget.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            //background circles
            const DecorativeCirclesBackground(),
            
            //main scrollable content
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        //button back
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            hoverColor: Colors.transparent,
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.black,
                            iconSize: 48,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Selamat datang di\nBIX Cinema',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          'Isi Data Dibawah untuk membuat akun baru\nBix Cinema kamu',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                                
                        const SizedBox(height: 30),

                        // Input Form disini
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Nama Lengkap',
                            labelStyle: TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF003D82)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Nomor',
                            labelStyle: TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF003D82)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Email ID',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Email',
                            labelStyle: TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF003D82)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Masukkan Password',
                            labelStyle: TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF003D82)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        
                        const Text(
                          'Password harus mengandung angka',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Minimal 6 karakter',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pastikan password mengandung huruf',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        const Text(
                          'Konfirmasi Password',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hoverColor: Colors.transparent,
                            labelText: 'Konfirmasi Password',
                            labelStyle: TextStyle(color: Colors.black54),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF003D82)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle register
                            },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor: const Color(0xFF003D82),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Daftar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  
                  //logo at the bottom
                  LogoBox(
                    imagePath: 'lib/assets/images/icons/iconbix.png',
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}