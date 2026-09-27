import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'preview_screen.dart';

/// Shows live % + cancel while engine works.
class PrepareScreen extends StatefulWidget {
  const PrepareScreen({super.key});
  @override
  State<PrepareScreen> createState() => _PrepareScreenState();
}

class _PrepareScreenState extends State<PrepareScreen> {
  double _p = 0;
  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    for (var i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _p = i / 5);
    }
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const PreviewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preparing')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: PrepareProgress(progress: _p, onCancel: () => Navigator.pop(context)),
      ),
    );
  }
}
