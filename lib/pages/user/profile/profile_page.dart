import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:bixcinema/core/models/user_model.dart';
import 'package:bixcinema/core/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/core/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import '../../../ui/widgets/loading_screen.dart';
import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:bixcinema/core/services/imgbbapi_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A237E)),
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

  class _ProfileScreenState extends State<ProfileScreen> {
    bool _isUploading = false;

  // Fungsi untuk handle upload avatar
  Future<void> _changeProfilePicture(String userId) async {
    final ImagePicker picker = ImagePicker();
    
    // 1. Pilih Gambar dari Galeri
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Kompres agar tidak terlalu berat
    );

    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      // 2. Upload ke ImgBB
      File file = File(image.path);
      String? avatarUrl = await ImgbbapiService.uploadImage(file);

      if (avatarUrl != null) {
        // 3. Update URL di Firebase (Asumsi ada fungsi update di FirebaseService kamu)
        // Pastikan kamu punya fungsi updateUserAvatar di FirebaseService
        avatarUrl = avatarUrl.replaceAll('http://i.ibb.co.com/', 'https://i.ibb.co.com/'); // Pastikan URL aman

        await FirebaseService.updateUserAvatar(userId, avatarUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
          );
        }
      } else {
        throw 'Gagal mendapatkan URL dari ImgBB';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override 
  Widget build(BuildContext context) {
    // final currentUser = FirebaseService.getCurrentAuthUser();
    // final userId = currentUser?.uid;
    // if (userId == null) {
    //   return Scaffold(body: Center(child: Text('User not found')));
    // }
    return StreamBuilder<User?>(
      stream: FirebaseService.authStateChanges(),
      builder: (context, authSnapshot) {
      if (!authSnapshot.hasData) {
        return Scaffold(body: Center(child: Text('User not logged in')));
      }
    
    final userId = authSnapshot.data!.uid;


    return FutureBuilder<UserModel?>(
      future: FirebaseService.getCurrentUser(userId),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            extendBody: true,
            body: const BixLoadingScreen(),
          );
        } else if (userSnapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error : ${userSnapshot.error}')),
          );
        }

        final user = userSnapshot.data;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: BixAppBar.subtitle(
            title: 'Profile',
            subtitle: user?.name ?? '',
            onBack: null,
            ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      // Avatar
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 32.0),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundColor: const Color(0xFF1A237E),
                                child: ClipOval(
                                  child: 
                                  user?.avatarUrl != null ? CachedNetworkImage(
                                    imageUrl: user!.avatarUrl!,
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) {

                                      print("Link Error: $url"); // Cek link yang bermasalah di log

                                    return const Icon(Icons.person, size: 55, color: Colors.white);
                                    
                                    },
                                  ): const Icon(Icons.person, size: 55, color: Colors.white),
                                ),
                              ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _changeProfilePicture(userId),
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A237E),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  // Profile section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go('/edit-profile');
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF1A237E),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 12, thickness: 1),

                        const SizedBox(height: 16),

                        // Full Name
                        _ProfileField(
                          label: 'Full Name',
                          value: user?.name ?? '',
                        ),

                        const SizedBox(height: 20),

                        // Phone Number
                        _ProfileField(
                          label: 'Phone Number',
                          value: user?.phoneNumber ?? '',
                        ),

                        const SizedBox(height: 20),

                        // Email
                        _ProfileField(
                          label: 'Email',
                          value: user?.email ?? ''
                        ),

                        const SizedBox(height: 24),

                        const Divider(height: 1, thickness: 1),

                        // Ubah Password row
                        InkWell(
                          onTap: () {
                            context.push('/change-password');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Ubah Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Divider(height: 1, thickness: 1),

                        const SizedBox(height: 32),

                        // Log Out Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _handleLogout,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } 
  );
}
  Future<void> _handleLogout() async {
    // 1. Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Tutup confirmation dialog
              
              // 2. Call AuthService.signOut() (bukan langsung Firebase)
              await AuthService.signOut();
              
              if (!mounted) return;
              
              // 3. Show success dialog
              showDialog(
                // ignore: use_build_context_synchronously
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout Berhasil'),
                  content: const Text('Anda telah berhasil keluar dari akun.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // 4. Navigate ke login page
                        context.go('/login');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Ya, Logout'),
          ),
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

