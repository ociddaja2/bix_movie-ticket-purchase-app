import 'package:flutter/material.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  int selectedDateIndex = 0;
  String? selectedShowtime;

  final List<Map<String, String>> dates = [
    {'label': 'Hari ini', 'day': '19'},
    {'label': 'Jum', 'day': '20'},
    {'label': 'Sabtu', 'day': '21'},
  ];

  final List<String> showtimes = ['14:25 - 16:40', '20:00 - 21:32'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(),
                    _buildMovieInfo(),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildSynopsis(),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildDateSelector(),
                    const Divider(thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildCinemaSection(),
                  ],
                ),
              ),
            ),
            _buildBuyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.black87,
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/en/thumb/0/0f/Avatar_Fire_and_Ash_poster.jpg/220px-Avatar_Fire_and_Ash_poster.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[800],
              child: const Center(
                child: Icon(Icons.movie, color: Colors.white54, size: 60),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.black.withOpacity(0.3),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, color: Colors.black87, size: 32),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/en/thumb/0/0f/Avatar_Fire_and_Ash_poster.jpg/220px-Avatar_Fire_and_Ash_poster.jpg',
              width: 64,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 64,
                height: 90,
                color: Colors.grey[300],
                child: const Icon(Icons.movie, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Avatar Fire And Ash',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'action-adventure, fantasy film',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildTag('3j 17m'),
                    _buildTag('13+'),
                    _buildTag('2D'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
    );
  }

  Widget _buildSynopsis() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sinopsis',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text:
                      'Setelah perang yang dahsyat melawan RDA dan kehilangan putra sulung mereka, Jake Sully (Sam Worthington) dan Neytiri (Zoe Saldana) menghadapi ancaman baru di Pandora: Suku Ash, suku Na\'vi yang kejam dan haus...',
                ),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Lihat Selengkapnya',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tayang',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(
              dates.length,
              (index) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = index;
                      selectedShowtime = null;
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        dates[index]['label']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: selectedDateIndex == index
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: selectedDateIndex == index
                              ? const Color(0xFF1A73E8)
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedDateIndex == index
                                ? const Color(0xFF1A73E8)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            dates[index]['day']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selectedDateIndex == index
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCinemaSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.location_on_outlined, color: Colors.black54, size: 20),
              SizedBox(width: 6),
              Text(
                'Q Mall Banjarbaru',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Padding(
            padding: EdgeInsets.only(left: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Reguler 2D',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  'Rp50.000',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: showtimes.map((time) {
              final isSelected = selectedShowtime == time;
              return GestureDetector(
                onTap: () => setState(() => selectedShowtime = time),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1A73E8)
                          : Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    color: isSelected
                        ? const Color(0xFFE8F0FE)
                        : Colors.white,
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? const Color(0xFF1A73E8)
                          : Colors.black54,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBuyButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: ElevatedButton(
        onPressed: selectedShowtime != null ? () {} : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A73E8),
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Beli Tiket',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}