import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_store.dart';

/// My activity: counts only in V1 (charts in Phase 9).
/// Regular sees Prepared/Shared/Saved. Owner also sees Views/Interests.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(dashboardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My activity')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _row('Files made', c.prepared),
          _row('Shared to WhatsApp', c.shared),
          _row('Saved', c.saved),
          const Divider(),
          _row('Views (owner)', c.views),
          _row('People keen (owner)', c.interests),
        ],
      ),
    );
  }

  Widget _row(String label, int n) => ListTile(
        title: Text(label),
        trailing: Text('$n', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      );
}
