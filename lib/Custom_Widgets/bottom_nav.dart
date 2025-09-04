import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<BottomNavigationBarItem> items;
  final Color selectedItemColor;
  final Color unselectedItemColor;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
    this.selectedItemColor = Colors.blueAccent,
    this.unselectedItemColor = Colors.grey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent.withOpacity(0.8), Colors.blue.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: items,
          //backgroundColor: Colors.transparent,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unselectedItemColor,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          iconSize: 30,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          selectedIconTheme: const IconThemeData(size: 32), // Larger icon for selected item
          unselectedIconTheme: const IconThemeData(size: 24), // Slightly smaller for unselected item
        ),
      ),
    );
  }
}
