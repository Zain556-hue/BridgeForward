import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// Pay wall stub. Shows plans, no real charge (Phase 9 rule).
class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Go Premium')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Free stays full. Premium adds more.',
              style: TextStyle(color: BridgeColors.muted)),
          const SizedBox(height: 12),
          const Card(child: ListTile(title: Text('Free'), subtitle: Text('Make, share, posts'))),
          const Card(
              child: ListTile(
                  title: Text('Premium'), subtitle: Text('More saves, deep counts, top spot'))),
          const Card(
              child: ListTile(
                  title: Text('Business'), subtitle: Text('Logo, link, seats, boost 7 days'))),
          const SizedBox(height: 12),
          BridgePrimaryButton(label: 'Later', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
