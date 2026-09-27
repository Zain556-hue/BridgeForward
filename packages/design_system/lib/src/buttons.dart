import 'package:flutter/material.dart';
import 'tokens.dart';

/// Min 48px tall touch targets. WhatsApp green ONLY on share button.
class BridgeWhatsAppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const BridgeWhatsAppButton({super.key, this.onPressed, this.label = 'Share to WhatsApp'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.send_rounded),
        label: Semantics(button: true, label: label, child: Text(label)),
        style: FilledButton.styleFrom(
          backgroundColor: BridgeColors.whatsapp,
          foregroundColor: BridgeColors.whatsappOn,
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BridgeRadii.sm)),
        ),
      ),
    );
  }
}

class BridgePrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const BridgePrimaryButton({super.key, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: BridgeColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BridgeRadii.sm)),
        ),
        child: Text(label),
      ),
    );
  }
}

class BridgeSecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const BridgeSecondaryButton({super.key, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: BridgeColors.primaryTint,
          foregroundColor: BridgeColors.primaryDark,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(BridgeRadii.sm)),
        ),
        child: Text(label),
      ),
    );
  }
}

class BridgeTertiaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  const BridgeTertiaryButton({super.key, this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: BridgeColors.muted,
        minimumSize: const Size(48, 48),
      ),
      child: Text(label),
    );
  }
}
