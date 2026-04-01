// Widget navbar
// fungsi ada di route.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kNavyMid = Color(0xFF1A237E);
const kTextGrey = Colors.grey;

class Navbar extends StatelessWidget {
  final int currentIndex;

  const Navbar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBottomNav(context);
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = [
      {
        'icon': Icons.home_rounded,
        'label': 'Home',
        'route': '/home',
      },
      {
        'icon': Icons.confirmation_number_outlined,
        'label': 'Booking',
        'route': '/booking',
      },
      {
        'icon': Icons.person_outline_rounded,
        'label': 'Profile',
        'route': '/profile',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(41, 0, 0, 0),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;
              return GestureDetector(
                onTap: () {
                  context.go(items[index]['route'] as String);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? kNavyMid : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        items[index]['icon'] as IconData,
                        color: isSelected ? Colors.white : kTextGrey,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        items[index]['label'] as String,
                        style: TextStyle(
                          color: isSelected ? Colors.white : kTextGrey,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
