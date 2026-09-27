import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../app.dart';

/// 3 pages: Value → Permission → Start. No login wall (Phase 3 rule).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});
  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = const PageController();
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: (i) => setState(() => _i = i),
                children: const [
                  _Step(title: 'Keep quality on WhatsApp', body: 'Select → Prepare → Share. No tech skills needed.'),
                  _Step(title: 'Your photos stay yours', body: 'Work happens on your phone. We ask for photo access only.'),
                  _Step(title: 'Ready in 30 seconds', body: 'Pick one photo, tap Share to WhatsApp.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: BridgePrimaryButton(
                label: _i < 2 ? 'Next' : 'Select media',
                onPressed: () {
                  if (_i < 2) {
                    _pages.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                  } else {
                    ref.read(firstRunProvider.notifier).state = false;
                  }
                },
              ),
            ),
            BridgeTertiaryButton(
              label: 'Skip',
              onPressed: () => ref.read(firstRunProvider.notifier).state = false,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String title, body;
  const _Step({required this.title, required this.body});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          Text(body, style: const TextStyle(color: BridgeColors.muted, fontSize: 16), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
