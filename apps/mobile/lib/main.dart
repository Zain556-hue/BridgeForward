import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';

void main() {
  runApp(const ProviderScope(child: BridgeForwardApp()));
}

class BridgeForwardApp extends StatelessWidget {
  const BridgeForwardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BridgeForward',
      theme: BridgeTheme.light(),
      darkTheme: BridgeTheme.dark(),
      home: const Scaffold(
        body: Center(
          child: Text('BridgeForward — Phase 0 scaffold.\nRun flutter pub get after SDK install.'),
        ),
      ),
    );
  }
}
