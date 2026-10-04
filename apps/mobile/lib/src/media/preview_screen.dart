import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../../app.dart';

/// After make: Before → After + 3 buttons. Copy: "Prepared for WhatsApp".
/// On any action, complete flow and go to AppShell.
class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PreviewTemplate(
            before: '24 MB',
            after: '18 MB',
            onShare: () {
              completeMediaFlow(ref);
              // TODO: call ShareService.shareToWhatsApp
            },
            onSave: () {
              completeMediaFlow(ref);
              // TODO: call ShareService.saveToDevice
            },
            onLater: () {
              completeMediaFlow(ref);
              // TODO: queue for later
            },
          ),
        ],
      ),
    );
  }
}