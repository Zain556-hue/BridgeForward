import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// Safety sheet: report bad post, block person, read rules.
/// Never force phone/email share (trust rule).
class TrustSheet extends StatelessWidget {
  final String listingTitle;
  const TrustSheet({super.key, required this.listingTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Stay safe', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Post: $listingTitle', style: const TextStyle(color: BridgeColors.muted)),
          const SizedBox(height: 8),
          const Text('• Keep chat in app.\n• Never send money or codes.\n• Meet in public for deals.',
              style: TextStyle(color: BridgeColors.muted)),
          const SizedBox(height: 12),
          BridgeSecondaryButton(label: 'Report this post', onPressed: () => Navigator.pop(context)),
          BridgeTertiaryButton(label: 'Block this person', onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}
