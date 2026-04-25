import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//  BIX Cinema — AppBar System
//  Gunakan named constructor sesuai halaman:
//
//  BixAppBar.logo()           → hanya logo
//  BixAppBar.home()           → logo + dropdown lokasi (Homepage)
//  BixAppBar.subtitle()       → logo + judul & deskripsi (MovieList, Booking, Profile)
//  BixAppBar.titled()         → back + judul halaman (Pembayaran)
//  BixAppBar.locationPicker() → back + logo + lokasi aktif (Pilih Lokasi)
//  BixAppBar.seatPicker()     → back + logo + info film & jadwal (Pilih Kursi)
//  BixAppBar.ticketDetail()   → back + logo + bioskop & waktu (Lihat Tiket)

const _kBlue = Color(0xFF1A2E7A);

class BixAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BixAppBar._({
    required _BixAppBarVariant variant,
    this.title,
    this.subtitle,
    this.location,
    this.movieTitle,
    this.cinema,
    this.timeRange,
    this.date,
    this.onBack,
    this.onLocationTap,
  }) : _variant = variant;

  // ── Named constructors ────────────────────

  const BixAppBar.logo()
      : this._(variant: _BixAppBarVariant.logo);

  const BixAppBar.home({
    required String location,
    VoidCallback? onLocationTap,
  }) : this._(
          variant: _BixAppBarVariant.home,
          location: location,
          onLocationTap: onLocationTap,
        );

  const BixAppBar.subtitle({
    required String title,
    String? subtitle,
  }) : this._(
          variant: _BixAppBarVariant.subtitle,
          title: title,
          subtitle: subtitle,
        );

  const BixAppBar.titled({
    required String title,
    VoidCallback? onBack,
  }) : this._(
          variant: _BixAppBarVariant.titled,
          title: title,
          onBack: onBack,
        );

  const BixAppBar.locationPicker({
    required String location,
    VoidCallback? onBack,
    VoidCallback? onLocationTap,
  }) : this._(
          variant: _BixAppBarVariant.locationPicker,
          location: location,
          onBack: onBack,
          onLocationTap: onLocationTap,
        );

  const BixAppBar.seatPicker({
    required String movieTitle,
    required String cinema,
    required String timeRange,
    required String date,
    VoidCallback? onBack,
  }) : this._(
          variant: _BixAppBarVariant.seatPicker,
          movieTitle: movieTitle,
          cinema: cinema,
          timeRange: timeRange,
          date: date,
          onBack: onBack,
        );

  const BixAppBar.ticketDetail({
    required String cinema,
    required String timeRange,
    VoidCallback? onBack,
  }) : this._(
          variant: _BixAppBarVariant.ticketDetail,
          cinema: cinema,
          timeRange: timeRange,
          onBack: onBack,
        );

  final _BixAppBarVariant _variant;
  final String? title;
  final String? subtitle;
  final String? location;
  final String? movieTitle;
  final String? cinema;
  final String? timeRange;
  final String? date;
  final VoidCallback? onBack;
  final VoidCallback? onLocationTap;

  @override
  Size get preferredSize {
    switch (_variant) {
    case _BixAppBarVariant.logo:
      return const Size.fromHeight(68);  // 56 + 12
    case _BixAppBarVariant.home:
      return const Size.fromHeight(110); // 56+2+40 + 12
    case _BixAppBarVariant.subtitle:
      return const Size.fromHeight(112);  // 56+2 + 12 (minimal)
    case _BixAppBarVariant.titled:
      return const Size.fromHeight(68);  // 56 + 12
    case _BixAppBarVariant.locationPicker:
      return const Size.fromHeight(112); // 56+4+40 + 12
    case _BixAppBarVariant.seatPicker:
      return const Size.fromHeight(122); // 56+6+32 + 12
    case _BixAppBarVariant.ticketDetail:
      return const Size.fromHeight(110); // 56+6+32 + 12
  }
}

  @override
  Widget build(BuildContext context) {
    return _BixAppBarContainer(
      child: switch (_variant) {
        _BixAppBarVariant.logo => const _LogoRow(),
        _BixAppBarVariant.home => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _LogoRow(),
              const SizedBox(height: 2),
              _LocationDropdown(
                location: location!,
                isOpen: false,
                onTap: onLocationTap,
              ),
            ],
          ),
        _BixAppBarVariant.subtitle => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _LogoRow(),
              const SizedBox(height: 2),
              _SubtitleBlock(title: title!, subtitle: subtitle),
            ],
          ),
        _BixAppBarVariant.titled => _BackTitleRow(
            title: title!,
            onBack: onBack,
          ),
        _BixAppBarVariant.locationPicker => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BackLogoRow(onBack: onBack),
              const SizedBox(height: 4),
              _LocationDropdown(
                location: location!,
                isOpen: true,
                onTap: onLocationTap,
              ),
            ],
          ),
        _BixAppBarVariant.seatPicker => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BackLogoRow(onBack: onBack),
              const SizedBox(height: 6),
              _FilmInfoCard(
                movieTitle: movieTitle!,
                cinema: cinema!,
                timeRange: timeRange!,
                date: date!,
              ),
            ],
          ),
        _BixAppBarVariant.ticketDetail => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BackLogoRow(onBack: onBack),
              const SizedBox(height: 6),
              _TicketInfoCard(cinema: cinema!, timeRange: timeRange!),
            ],
          ),
      },
    );
  }
}

//  Enum variant AppBar
enum _BixAppBarVariant {
  logo,
  home,
  subtitle,
  titled,
  locationPicker,
  seatPicker,
  ticketDetail,
}


//  Container latar biru
class _BixAppBarContainer extends StatelessWidget {
  const _BixAppBarContainer({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _kBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: child,
        ),
      ),
    );
  }
}

//  Logo BIX Cinema (besar)
class _LogoRow extends StatelessWidget {
  const _LogoRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Center(
        child: Image.asset('lib/assets/images/icons/iconbix3.png', height: 28, fit: BoxFit.contain),
      ),
    );
  }
}

//  Baris back + logo kecil di tengah
class _BackLogoRow extends StatelessWidget {
  const _BackLogoRow({this.onBack});
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _BackButton(onTap: onBack ?? () => Navigator.maybePop(context)),
          ),
          Image.asset('lib/assets/images/icons/iconbix3.png', height: 24, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

//  Baris back + judul teks (tanpa logo)
class _BackTitleRow extends StatelessWidget {
  const _BackTitleRow({required this.title, this.onBack});
  final String title;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _BackButton(onTap: onBack ?? () => Navigator.maybePop(context)),
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

//  Tombol back
class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
      ),
    );
  }
}

//  Subtitle block
class _SubtitleBlock extends StatelessWidget {
  const _SubtitleBlock({required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ],
    );
  }
}

//  Dropdown lokasi
class _LocationDropdown extends StatelessWidget {
  const _LocationDropdown({required this.location, required this.isOpen, this.onTap});
  final String location;
  final bool isOpen;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              const Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(location,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
            ]),
            Icon(isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

//  Info card — film & jadwal (Pilih Kursi)
class _FilmInfoCard extends StatelessWidget {
  const _FilmInfoCard({
    required this.movieTitle,
    required this.cinema,
    required this.timeRange,
    required this.date,
  });
  final String movieTitle, cinema, timeRange, date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(movieTitle,
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(cinema, style: TextStyle(color: Colors.white.withOpacity(0.65), fontSize: 11)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(timeRange, style: const TextStyle(color: Colors.white, fontSize: 12)),
            const SizedBox(height: 2),
            Text(date, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
          ]),
        ],
      ),
    );
  }
}


//  Info card — bioskop & waktu (Lihat Tiket)

class _TicketInfoCard extends StatelessWidget {
  const _TicketInfoCard({required this.cinema, required this.timeRange});
  final String cinema, timeRange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(cinema,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(timeRange, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}

//  Demo App


class BixDemoApp extends StatelessWidget {
  const BixDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BIX Cinema',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _kBlue), useMaterial3: true),
      home: const _DemoHome(),
    );
  }
}

class _DemoHome extends StatelessWidget {
  const _DemoHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BixAppBar.home(location: 'Banjarbaru', onLocationTap: () {}),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NavTile('MovieList — Sedang Tayang', () => _push(context, _SedangTayangPage())),
          _NavTile('MovieList — Akan Datang', () => _push(context, _AkanDatangPage())),
          _NavTile('Pilih Lokasi Bioskop', () => _push(context, _PilihLokasiPage())),
          _NavTile('Pilih Kursi', () => _push(context, _PilihKursiPage())),
          _NavTile('Konfirmasi Pembayaran', () => _push(context, _PembayaranPage())),
          _NavTile('Booking', () => _push(context, _BookingPage())),
          _NavTile('Lihat Tiket', () => _push(context, _LihatTiketPage())),
          _NavTile('Profile / Account', () => _push(context, _ProfilePage())),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));
}

Widget _NavTile(String label, VoidCallback onTap) => ListTile(
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );

class _SedangTayangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const BixAppBar.subtitle(
          title: 'Sedang Tayang',
          subtitle: 'Sedang tayang hari ini di BIX Cinema ✦',
        ),
        body: const Center(child: Text('Daftar film sedang tayang')),
      );
}

class _AkanDatangPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const BixAppBar.subtitle(
          title: 'Akan Mendatang',
          subtitle: 'Rencanakan tontonanmu dari sekarang! ✦',
        ),
        body: const Center(child: Text('Daftar film akan datang')),
      );
}

class _PilihLokasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BixAppBar.locationPicker(
          location: 'Banjarbaru',
          onBack: () => Navigator.pop(context),
          onLocationTap: () {},
        ),
        body: const Center(child: Text('Daftar bioskop')),
      );
}

class _PilihKursiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BixAppBar.seatPicker(
          movieTitle: 'Avatar Fire And Ash',
          cinema: 'Q Mall Banjarbaru',
          timeRange: '14:25 - 16:40',
          date: 'Kam, 19 2026',
          onBack: () => Navigator.pop(context),
        ),
        body: const Center(child: Text('Layout kursi')),
      );
}

class _PembayaranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BixAppBar.titled(
          title: 'Konfirmasi Pembayaran',
          onBack: () => Navigator.pop(context),
        ),
        body: const Center(child: Text('Form pembayaran')),
      );
}

class _BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const BixAppBar.subtitle(
          title: 'Booking',
          subtitle: 'Menampilkan detail pesanan tiket yang sudah di Booking',
        ),
        body: const Center(child: Text('Detail booking')),
      );
}

class _LihatTiketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BixAppBar.ticketDetail(
          cinema: 'Q Mall Banjarbaru',
          timeRange: '14:25 - 16:40',
          onBack: () => Navigator.pop(context),
        ),
        body: const Center(child: Text('Detail tiket yang dibeli')),
      );
}

class _ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const BixAppBar.subtitle(
          title: 'Account',
          subtitle: 'Tempat untuk melihat dan mengatur Akun anda',
        ),
        body: const Center(child: Text('Halaman profil')),
      );
}