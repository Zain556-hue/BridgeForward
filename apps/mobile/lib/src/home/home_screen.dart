import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// Home tab: big entry to Media Core (Phase 4 wires real picker).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Home', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
          SizedBox(height: 8),
          Text('Select → Prepare → Share', style: TextStyle(color: BridgeColors.muted)),
          SizedBox(height: 20),
          MediaCard(title: 'Try it now', subtitle: 'Pick a photo or video', isVideo: false),
        ],
      ),
    );
  }
}
