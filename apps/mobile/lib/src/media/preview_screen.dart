import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// After make: Before → After + 3 buttons. Copy: "Prepared for WhatsApp".
class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const PreviewTemplate(before: '24 MB', after: '18 MB'),
        ],
      ),
    );
  }
}
