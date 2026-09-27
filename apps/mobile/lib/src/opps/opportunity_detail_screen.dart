import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../discover/discover_store.dart';

/// Post page + 4 safe buttons. No personal info shown.
/// Tap writes an interest row + tells owner (net part in Phase 7).
class OpportunityDetailScreen extends ConsumerStatefulWidget {
  final Listing listing;
  const OpportunityDetailScreen({super.key, required this.listing});
  @override
  ConsumerState<OpportunityDetailScreen> createState() => _OpportunityDetailScreenState();
}

class _OpportunityDetailScreenState extends ConsumerState<OpportunityDetailScreen> {
  String? _sent;

  @override
  Widget build(BuildContext context) {
    final l = widget.listing;
    return Scaffold(
      appBar: AppBar(title: Text(l.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l.description),
          const SizedBox(height: 8),
          Text('Stage: ${l.stage}', style: const TextStyle(color: BridgeColors.muted)),
          const SizedBox(height: 16),
          if (_sent != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: BridgeColors.primaryTint, borderRadius: BorderRadius.circular(12)),
              child: Text('Sent: $_sent'),
            ),
          const SizedBox(height: 8),
          BridgePrimaryButton(label: 'Interested', onPressed: () => _send('interested')),
          const SizedBox(height: 8),
          BridgeSecondaryButton(label: 'Connect', onPressed: () => _send('connect')),
          BridgeTertiaryButton(label: 'Ask for deal info', onPressed: () => _send('info_request')),
          BridgeTertiaryButton(label: 'Ask to work together', onPressed: () => _send('collab_request')),
        ],
      ),
    );
  }

  void _send(String kind) => setState(() => _sent = kind);
}
