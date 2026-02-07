import 'package:flutter/material.dart';
import '../../services/analytics_service.dart';
import 'outcomes_screen.dart';
import 'library_screen.dart';
// Templates import removed

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0; // Start on Library (home)

  final List<Widget> _screens = const [
    LibraryScreen(),    // Index 0 (Home)
    OutcomesScreen(),   // Index 1
  ];

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF000000);
    final surfaceColor = const Color(0xFF1A1A1A);
    final primaryColor = const Color(0xFF3B82F6);
    final textColor = Colors.white;
    final secondaryTextColor = const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(
            top: BorderSide(
              color: surfaceColor,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.library_books,
                  label: 'Library',
                  index: 0,
                  primaryColor: primaryColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                _buildNavItem(
                  icon: Icons.dashboard,
                  label: 'Outcomes',
                  index: 1,
                  primaryColor: primaryColor,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color primaryColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          final tabNames = ['Library', 'Outcomes'];
          AnalyticsService().logTabSelected(tabName: tabNames[index]);
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      primaryColor.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? primaryColor : secondaryTextColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? primaryColor : secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
