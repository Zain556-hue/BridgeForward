import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../app.dart';

/// First screen users see: clean landing page explaining value prop.
/// CTA goes directly to media selection (PickScreen).
class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Logo / Brand
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [BridgeColors.primary, BridgeColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.high_quality_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 24),
              // Headline
              const Text(
                'Share Photos & Videos\nWithout Losing Quality',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  color: BridgeColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              // Sub-headline
              const Text(
                'WhatsApp compresses your media. BridgeForward prepares it\nso what you send looks as good as the original.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: BridgeColors.muted,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Value props (3 columns)
              _ValueRow(),
              const SizedBox(height: 40),
              // Main CTA
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: () => ref.read(appRouteProvider.notifier).state = AppRoute.mediaFlow,
                  icon: const Icon(Icons.send_rounded, size: 22),
                  label: const Text(
                    'Preserve My Media',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: BridgeColors.whatsapp,
                    foregroundColor: BridgeColors.whatsappOn,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(BridgeRadii.sm),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Secondary CTA
              TextButton(
                onPressed: () => ref.read(appRouteProvider.notifier).state = AppRoute.mediaFlow,
                child: const Text(
                  'Get Started — It\'s Free',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: BridgeColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Trust line
              Text(
                'No account needed to try. Your files stay on your device.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: BridgeColors.muted),
              ),
              const SizedBox(height: 24),
              // How it works (compact)
              _HowItWorks(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ValueChip(icon: Icons.image_outlined, label: 'Photos'),
        const SizedBox(width: 12),
        _ValueChip(icon: Icons.videocam_outlined, label: 'Videos'),
        const SizedBox(width: 12),
        _ValueChip(icon: Icons.whatsapp_outlined, label: 'WhatsApp Ready'),
      ],
    );
  }
}

class _ValueChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ValueChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: BridgeColors.primaryTint,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: BridgeColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: BridgeColors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: BridgeColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const steps = [
      ('1', 'Select', 'Pick from gallery, camera, or share to BridgeForward'),
      ('2', 'Prepare', 'We optimize for WhatsApp — no quality loss'),
      ('3', 'Share', 'Send as file to WhatsApp, save, or share elsewhere'),
    ];
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: BridgeColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  steps[i].$1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      steps[i].$2,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: BridgeColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      steps[i].$3,
                      style: const TextStyle(
                        fontSize: 14,
                        color: BridgeColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (i < steps.length - 1) const SizedBox(height: 20),
        ],
      ],
    );
  }
}