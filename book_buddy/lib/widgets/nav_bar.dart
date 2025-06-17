import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool isDarkMode;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The container wraps the BottomNavigationBar for custom styling.
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white : Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Library - book icon',
              hint: 'Press to go to My Library screen',
              child: Icon(
                Icons.menu_book,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'TBR - bookmark icon',
              hint: 'Press to go to My TBR screen',
              child: Icon(
                Icons.bookmark,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Scan book - camera icon',
              hint: 'Press to go to Scan Book screen',
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.white70 : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Settings - settings icon',
              hint: 'Press to go to Settings screen',
              child: Icon(
                Icons.settings,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Semantics(
              label: 'Home - home icon',
              hint: 'Press to go to Home screen',
              child: Icon(
                Icons.home,
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
