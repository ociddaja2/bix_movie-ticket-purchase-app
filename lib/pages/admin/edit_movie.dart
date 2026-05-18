import 'package:bixcinema/core/models/movie_model.dart';
import 'package:flutter/material.dart';

class EditMoviePage extends StatefulWidget {
  final MovieModel movie;

  const EditMoviePage({
    super.key,
    required this.movie,
  });

  @override
  State<EditMoviePage> createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _genreController;
  late final TextEditingController _durationController;
  late final TextEditingController _ratingController;
  late final TextEditingController _synopsisController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie.judul);
    _genreController = TextEditingController(text: widget.movie.genre.join(', '));
    _durationController = TextEditingController(text: widget.movie.durasi);
    _ratingController = TextEditingController(text: widget.movie.rating);
    _synopsisController = TextEditingController(text: widget.movie.sinopsis);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _ratingController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

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
          'Edit Film',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Film',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text('Nama Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.black87),
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'masukkan nama film',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Genre Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.black87),
              controller: _genreController,
              decoration: InputDecoration(
                hintText: 'masukkan genre film',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Durasi Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.black87),
              controller: _durationController,
              decoration: InputDecoration(
                hintText: 'contoh "3j 17m"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Batas Usia Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.black87),
              controller: _ratingController,
              decoration: InputDecoration(
                hintText: 'contoh "13+"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Sinopsis Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              style: const TextStyle(color: Colors.black87),
              controller: _synopsisController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'masukkan Sinopsis film',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Poster Film *', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file, color: Colors.black54),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.movie.posterUrl.split('/').last,
                      style: const TextStyle(color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Atur Jadwal Tayang *', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black)),
            const SizedBox(height: 8),
            const Text('Pilih jadwal tayang film untuk dipublikasikan', style: TextStyle(fontSize: 12, color: Colors.black)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, size: 20 , color: Colors.black54),
                  SizedBox(width: 8),
                  Text('Pilih lokasi Bioskop',
                  style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Atur tanggal Tayang',
                        style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.access_time, size: 20, color: Colors.black54),
                        SizedBox(width: 8),
                        Text('Atur jam tayang',
                        style: TextStyle(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Atur Jadwal Tayang Terlebih Dahulu',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromARGB(255, 49, 49, 49)),
              ),
            ),
            const SizedBox(height: 16),
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
