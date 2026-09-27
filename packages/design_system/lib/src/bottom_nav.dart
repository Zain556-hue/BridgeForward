import 'package:flutter/material.dart';
import 'tokens.dart';

/// Bottom tabs: Home / History / Discover / Profile (PRD §9 + §12).
class BridgeBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  const BridgeBottomNav({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: onTap,
      backgroundColor: BridgeColors.paper,
      indicatorColor: BridgeColors.primaryTint,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        NavigationDestination(icon: Icon(Icons.explore_outlined), selectedIcon: Icon(Icons.explore), label: 'Discover'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
