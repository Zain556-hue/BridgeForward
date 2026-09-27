import 'package:flutter/material.dart';
import 'tokens.dart';
import 'buttons.dart';

/// Preview screen template: Before/After size + "Prepared for WhatsApp" + 3 CTAs.
/// Copy rule: NEVER say "Lossless".
class PreviewTemplate extends StatelessWidget {
  final String before;
  final String after;
  final VoidCallback? onShare;
  final VoidCallback? onSave;
  final VoidCallback? onLater;
  const PreviewTemplate({
    super.key,
    required this.before,
    required this.after,
    this.onShare,
    this.onSave,
    this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: BridgeColors.primaryTint,
            borderRadius: BorderRadius.circular(BridgeRadii.md),
            border: Border.all(color: BridgeColors.line),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: BridgeColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Prepared for WhatsApp\n$before → $after',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        BridgeWhatsAppButton(onPressed: onShare),
        const SizedBox(height: 8),
        BridgeSecondaryButton(onPressed: onSave, label: 'Save to device'),
        BridgeTertiaryButton(onPressed: onLater, label: 'Do it later →'),
      ],
    );
  }
}
