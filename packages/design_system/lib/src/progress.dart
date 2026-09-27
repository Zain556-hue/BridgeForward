import 'package:flutter/material.dart';
import 'tokens.dart';

/// Cancellable prepare progress (Phase 4 needs % + cancel).
class PrepareProgress extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final VoidCallback? onCancel;
  const PrepareProgress({super.key, required this.progress, this.onCancel});

  @override
  Widget build(BuildContext context) {
    final pct = (progress * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: BridgeColors.primaryTint,
            valueColor: const AlwaysStoppedAnimation(BridgeColors.primary),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: Text('Preparing… $pct%', style: const TextStyle(color: BridgeColors.muted))),
            if (onCancel != null)
              TextButton(onPressed: onCancel, child: const Text('Cancel')),
          ],
        ),
      ],
    );
  }
}
