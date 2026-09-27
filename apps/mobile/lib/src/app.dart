import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'onboarding/onboarding_screen.dart';
import 'home/home_screen.dart';
import 'history/history_screen.dart';
import 'discover/discover_screen.dart';
import 'profile/profile_screen.dart';

/// App shell: bottom tabs Home / History / Discover / Profile.
/// First run shows onboarding, then shell. Login only for sync (Phase 3 rule).
final firstRunProvider = StateProvider<bool>((_) => true);
final tabIndexProvider = StateProvider<int>((_) => 0);

class BridgeForwardApp extends ConsumerWidget {
  const BridgeForwardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstRun = ref.watch(firstRunProvider);
    return MaterialApp(
      title: 'BridgeForward',
      theme: BridgeTheme.light(),
      darkTheme: BridgeTheme.dark(),
      home: firstRun ? const OnboardingScreen() : const AppShell(),
    );
  }
}

class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(tabIndexProvider);
    const screens = [HomeScreen(), HistoryScreen(), DiscoverScreen(), ProfileScreen()];
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BridgeBottomNav(
        index: index,
        onTap: (i) => ref.read(tabIndexProvider.notifier).state = i,
      ),
    );
  }
}
