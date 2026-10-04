import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'landing/landing_page.dart';
import 'home/home_screen.dart';
import 'history/history_screen.dart';
import 'discover/discover_screen.dart';
import 'profile/profile_screen.dart';

/// Navigation state: landing → media flow → app shell
enum AppRoute { landing, mediaFlow, appShell }

final appRouteProvider = StateProvider<AppRoute>((_) => AppRoute.landing);
final tabIndexProvider = StateProvider<int>((_) => 0);

class BridgeForwardApp extends ConsumerWidget {
  const BridgeForwardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(appRouteProvider);
    return MaterialApp(
      title: 'BridgeForward',
      theme: BridgeTheme.light(),
      darkTheme: BridgeTheme.dark(),
      home: switch (route) {
        AppRoute.landing => const LandingPage(),
        AppRoute.mediaFlow => const MediaFlowNavigator(),
        AppRoute.appShell => const AppShell(),
      },
    );
  }
}

/// Handles the media flow: Pick → Prepare → Preview → AppShell
class MediaFlowNavigator extends StatelessWidget {
  const MediaFlowNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    // Start with PickScreen; navigation pushes through Prepare → Preview
    // After Preview "Share/Save", app code should call:
    // ref.read(appRouteProvider.notifier).state = AppRoute.appShell;
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/prepare') {
          return MaterialPageRoute(builder: (_) => const PrepareScreen());
        }
        if (settings.name == '/preview') {
          return MaterialPageRoute(builder: (_) => const PreviewScreen());
        }
        return MaterialPageRoute(builder: (_) => const PickScreen());
      },
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

/// Call this after user completes media flow (from PreviewScreen)
void completeMediaFlow(WidgetRef ref) {
  ref.read(appRouteProvider.notifier).state = AppRoute.appShell;
}