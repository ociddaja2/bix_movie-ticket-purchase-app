import 'package:flutter/material.dart';

class AddMoviePage extends StatelessWidget {
  const AddMoviePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B6E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Film',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Tambah Film',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Nama Film
            const Text('Nama Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'masukkan nama film',
                hintStyle: const TextStyle(color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Genre Film
            const Text('Genre Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'masukkan genre film',
                hintStyle: const TextStyle(color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Durasi Film
            const Text('Durasi Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'contoh "3j 17m"',
                hintStyle: const TextStyle(color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Batas Usia Film
            const Text('Batas Usia Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'contoh "13+"',
                hintStyle: const TextStyle(color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Sinopsis Film
            const Text('Sinopsis Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'masukkan Sinopsis film',
                hintStyle: const TextStyle(color: Colors.black45),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            
            // Poster Film
            const Text('Poster Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              label: const Text('Upload Poster Film (JPG/JPEG)', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3B6E),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
            ),
            const SizedBox(height: 24),
            
            // Atur Jadwal Tayang Section
            const Text('Atur Jadwal Tayang *', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 8),
            const Text('Pilih jadwal tayang film untuk di publikasikan', style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 0, 0, 0))),
            const SizedBox(height: 12),
            
            // Location Dropdown
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Color.fromARGB(255, 0, 0, 0)),
                  SizedBox(width: 8),
                  Text('Pilih lokasi Bioskop', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Date and Time Pickers
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20, color: Color.fromARGB(255, 0, 0, 0)),
                        SizedBox(width: 8),
                        Text('Atur tanggal Tayang', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.access_time, size: 20, color: Color.fromARGB(255, 0, 0, 0)),
                        SizedBox(width: 8),
                        Text('Atur jam tayang',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Schedules List
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Atur Jadwal Tayang Terlebih Dahulu',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Add Schedule Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Tambah Jadwal Tayang',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3B6E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}