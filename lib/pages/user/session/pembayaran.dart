// lib/pages/user/session/pembayaran.dart
import 'package:bixcinema/ui/widgets/appbar_2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bixcinema/core/repo/pembayaran_repo.dart';
import 'package:bixcinema/core/repo/kursi_repo.dart';
import 'package:go_router/go_router.dart';

class PembayaranPage extends StatefulWidget {
  final String pembayaranId;
  final List<Map<String, dynamic>> seats;

  const PembayaranPage({
    super.key,
    required this.pembayaranId,
    required this.seats,
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  late Future<Map<String, dynamic>?> _pembayaranFuture;
  bool _isProcessing = false;

  // final hargaLayanan = 2000; // Contoh biaya layanan per transaksi

  @override
  void initState() {
    super.initState();
    _pembayaranFuture = PembayaranRepository().getPembayaran(widget.pembayaranId);
  }

  // ✅ Handle pembayaran
  Future<void> _handlePayment(Map<String, dynamic> pembayaranId) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      // Simulasi proses pembayaran (dalam real: integrasi dengan Midtrans/payment gateway)
      await Future.delayed(const Duration(seconds: 2));

      // Update status pembayaran ke "paid"
      await PembayaranRepository().confirmPembayaran(widget.pembayaranId);

      // Sekarang baru book kursi ke collection 'kursi'
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final tayangId = pembayaranId['tayangId'] as String;

      await KursiRepository().bookSeats(
        tayangId: tayangId,
        userId: userId,
        seats: widget.seats,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Pembayaran berhasil! Kursi telah dipesan.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate ke halaman sukses atau booking
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/booking');
          }
        });
      }
    } catch (e) {
      print('Error processing payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Pembayaran gagal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BixAppBar.subtitle(
        title: 'Booking',
        subtitle: 'Detail Pembayaran',
        onBack: () => context.go('/home'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _pembayaranFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1A3A8F),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Gagal memuat data pembayaran'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          final pembayaran = snapshot.data!;
          final seats = pembayaran['seats'] as List<dynamic>? ?? [];
          final totalHarga = pembayaran['totalHarga'] as int? ?? 0;
          final status = pembayaran['status'] as String? ?? 'pending';

          return SingleChildScrollView(
            child: Column(
              children: [
                // Status indicator
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: status == 'pending'
                        ? const Color(0xFFFFF3E0)
                        : const Color(0xFFE8F5E9),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        status == 'pending'
                            ? Icons.schedule
                            : Icons.check_circle,
                        color: status == 'pending'
                            ? const Color(0xFFF57C00)
                            : Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status == 'pending'
                                  ? 'Menunggu Pembayaran'
                                  : 'Pembayaran Berhasil',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: status == 'pending'
                                    ? const Color(0xFFF57C00)
                                    : Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ID Pembayaran: ${widget.pembayaranId}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Detail Kursi
                      const Text(
                        'Detail Kursi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kursi yang dipesan
                            Wrap(
                              spacing: 8,
                              children: List.generate(
                                seats.length,
                                (index) {
                                  final seat = seats[index];
                                  final row = seat['row'] ?? '';
                                  final number = seat['number'] ?? 0;
                                  return Chip(
                                    label: Text(
                                      '$row$number',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    backgroundColor:
                                        const Color(0xFF1A3A8F),
                                    side: const BorderSide(
                                      color: Color(0xFF1A3A8F),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Total Kursi: ${seats.length}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Ringkasan Harga
                      const Text(
                        'Ringkasan Harga',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            // Harga per kursi
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${seats.length} × Kursi Reguler 2D',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Rp${_formatPrice((pembayaran['harga'] as int? ?? 0) * seats.length)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Biaya Layanan',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Rp${_formatPrice(pembayaran['biayaLayanan'] as int? ?? 0)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Divider(color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            // Total
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Pembayaran',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Rp${_formatPrice(
                                  totalHarga + (pembayaran['biayaLayanan'] as int? ?? 0)

                                  )}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A3A8F),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Metode Pembayaran
                      const Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade50,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.credit_card, color: Color(0xFF1A3A8F)),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transfer Bank (Simulasi)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Klik tombol Bayar untuk simulasi',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Debug Info
                      if (status == 'pending')
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            border: Border.all(color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Debug Info:',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Pembayaran ID: ${widget.pembayaranId}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Courier',
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Jumlah Kursi: ${seats.length}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Courier',
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                'Total: Rp${_formatPrice(totalHarga 
                                // + biayaLayanan
                                )}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'Courier',
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<Map<String, dynamic>?>(
        future: _pembayaranFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final pembayaran = snapshot.data!;
          final status = pembayaran['status'] as String? ?? 'pending';

          if (status != 'pending') {
            return Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '✅ Pembayaran Berhasil',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _isProcessing
                  ? null
                  : () => _handlePayment(pembayaran),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A8F),
                disabledBackgroundColor: Colors.grey.shade300,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Bayar Sekarang',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}