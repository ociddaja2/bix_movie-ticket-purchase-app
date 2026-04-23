import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  BIX Cinema – Custom AppBar
// ─────────────────────────────────────────────

/// AppBar utama BIX Cinema.
///
/// [actionWidget] adalah slot opsional yang berubah-ubah per halaman.
/// Jika null, hanya logo yang ditampilkan.
class BixAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BixAppBar({
    super.key,
    this.actionWidget,
  });

  /// Widget yang tampil di baris kedua (contoh: tombol lokasi, tombol tanggal, dll.)
  /// Bila null, baris kedua tidak dirender.
  final Widget? actionWidget;

  @override
  Size get preferredSize => Size.fromHeight(actionWidget != null ? 108 : 64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A2E7A), // biru tua BIX
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Baris 1: Logo BIX Cinema ──────────────────────
            const _BixLogo(),

            // ── Baris 2: Slot aksi (opsional) ─────────────────
            if (actionWidget != null) ...[
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: actionWidget,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Logo widget (selalu tampil)
// ─────────────────────────────────────────────

class _BixLogo extends StatelessWidget {
  const _BixLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Center(
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'BIX ',
                style: TextStyle(
                  fontFamily: 'Georgia', // serif untuk "BIX"
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              TextSpan(
                text: 'cinema',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Tombol Lokasi  (dipakai di halaman beranda)
// ─────────────────────────────────────────────

class BixLocationButton extends StatelessWidget {
  const BixLocationButton({
    super.key,
    required this.location,
    this.onTap,
  });

  final String location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down,
                color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Contoh: Chip pencarian (halaman search)
// ─────────────────────────────────────────────

class BixSearchBar extends StatelessWidget {
  const BixSearchBar({
    super.key,
    this.hint = 'Cari film...',
    this.onTap,
  });

  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Text(
              hint,
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Demo lengkap — jalankan file ini langsung
// ─────────────────────────────────────────────

void main() => runApp(const BixDemoApp());

class BixDemoApp extends StatelessWidget {
  const BixDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIX Cinema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A2E7A)),
        useMaterial3: true,
      ),
      home: const _DemoNav(),
    );
  }
}

class _DemoNav extends StatefulWidget {
  const _DemoNav();

  @override
  State<_DemoNav> createState() => _DemoNavState();
}

class _DemoNavState extends State<_DemoNav> {
  int _index = 0;

  static const _pages = [
    _HomeScreen(),
    _SearchScreen(),
    _ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.search_outlined), label: 'Cari'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

// ── Halaman Home – pakai BixLocationButton ────
class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BixAppBar(
        actionWidget: BixLocationButton(
          location: 'Banjarbaru',
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ganti lokasi...')),
          ),
        ),
      ),
      body: const Center(child: Text('Halaman Beranda')),
    );
  }
}

// ── Halaman Search – pakai BixSearchBar ───────
class _SearchScreen extends StatelessWidget {
  const _SearchScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BixAppBar(
        actionWidget: BixSearchBar(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Buka keyboard...')),
          ),
        ),
      ),
      body: const Center(child: Text('Halaman Pencarian')),
    );
  }
}

// ── Halaman Profil – hanya logo, tanpa aksi ───
class _ProfileScreen extends StatelessWidget {
  const _ProfileScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: BixAppBar(), // actionWidget = null → hanya logo
      body: Center(child: Text('Halaman Profil')),
    );
  }
}