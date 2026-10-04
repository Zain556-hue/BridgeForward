import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../app.dart';
import '../dashboard/dashboard_screen.dart';
import '../search/search_screen.dart';
import '../notifications/notifications_screen.dart';

/// Home tab: shows recent activity + button to start new media prep.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Home', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Select → Prepare → Share', style: TextStyle(color: BridgeColors.muted)),
          const SizedBox(height: 20),
          const MediaCard(title: 'New media', subtitle: 'Prepare another photo or video', isVideo: false),
          const SizedBox(height: 12),
          BridgePrimaryButton(
            label: 'Prepare new media',
            onPressed: () => ref.read(appRouteProvider.notifier).state = AppRoute.mediaFlow,
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