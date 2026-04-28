import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BixAppBar.subtitle(
        title: 'Booking',
        subtitle: 'Detail Pemesanan',
        onBack: () => context.go('/home'),
        ),
      body: Center(
        child: Text('This is the booking page.'),
      ),
    );
  }
}