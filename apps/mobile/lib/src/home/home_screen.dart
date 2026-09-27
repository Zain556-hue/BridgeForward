import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import '../media/pick_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../search/search_screen.dart';
import '../notifications/notifications_screen.dart';

/// Home tab: big entry to Media Core.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Home', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Select → Prepare → Share', style: TextStyle(color: BridgeColors.muted)),
          const SizedBox(height: 20),
          const MediaCard(title: 'Try it now', subtitle: 'Pick a photo or video', isVideo: false),
          const SizedBox(height: 12),
          BridgePrimaryButton(
            label: 'Select media',
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const PickScreen())),
          ),
          const SizedBox(height: 8),
          BridgeSecondaryButton(
            label: 'My activity',
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const DashboardScreen())),
          ),
          const SizedBox(height: 8),
          BridgeSecondaryButton(
            label: 'Search posts',
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const SearchScreen())),
          ),
          BridgeTertiaryButton(
            label: 'Alerts →',
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const NotificationsScreen())),
          ),
        ],
      ),
    );
  }
}
