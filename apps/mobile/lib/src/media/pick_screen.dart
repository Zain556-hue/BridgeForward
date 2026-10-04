import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'prepare_screen.dart';

/// Entry: Upload / Pick from device / In from other app (share-intent).
class PickScreen extends ConsumerWidget {
  const PickScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select media')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          BridgePrimaryButton(
            label: 'Upload photo / video',
            onPressed: () => _fakePick(context, 'upload'),
          ),
          const SizedBox(height: 8),
          BridgeSecondaryButton(
            label: 'Pick from device',
            onPressed: () => _fakePick(context, 'device'),
          ),
          const SizedBox(height: 8),
          const Text('Or send a file to BridgeForward from Gallery / Files.',
              style: TextStyle(color: BridgeColors.muted)),
        ],
      ),
    );
  }

  void _fakePick(BuildContext context, String from) {
    // Real image_picker + receive_sharing_intent wired after SDK ready.
    Navigator.pushNamed(context, '/prepare');
  }
}
