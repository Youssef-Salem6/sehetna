import 'package:flutter/material.dart';
import 'package:sehetna/const.dart';
import 'package:sehetna/fetures/appointments/view/appointment_view.dart';
import 'package:sehetna/fetures/home/view/home_view.dart';
import 'package:sehetna/fetures/profile/view/profile_view.dart';
import 'package:sehetna/generated/l10n.dart';

class NavView extends StatefulWidget {
  const NavView({super.key});

  @override
  State<NavView> createState() => _NavViewState();
}

class _NavViewState extends State<NavView> {
  late final PageController _pageController;
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    AppointmentView(key: PageStorageKey('AppointmentView')),
    HomeView(key: PageStorageKey('HomeView')),
    ProfileView(key: PageStorageKey('ProfileView')),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Important for transparent nav bar
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8), // Add bottom padding
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.7),
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildNavItem(Icons.calendar_month, S.of(context).appointment, 0),
              _buildNavItem(Icons.home, S.of(context).home, 1),
              _buildNavItem(Icons.person, S.of(context).profile, 2),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final iconSize = isSelected ? 28.0 : 24.0;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Icon(icon, size: iconSize),
      ),
      label: label,
      tooltip: '', // Removes tooltip for cleaner interaction
    );
  }
}
