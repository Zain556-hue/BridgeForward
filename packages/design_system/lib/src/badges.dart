import 'package:flutter/material.dart';
import 'tokens.dart';

enum BridgeRole { creator, investor, collaborator, buyer }

/// Small role tag. All V2 colors (Phase 1.1).
class RoleBadge extends StatelessWidget {
  final BridgeRole role;
  const RoleBadge({super.key, required this.role});

  String get _label => switch (role) {
        BridgeRole.creator => 'Creator',
        BridgeRole.investor => 'Investor',
        BridgeRole.collaborator => 'Collaborator',
        BridgeRole.buyer => 'Buyer',
      };

  (Color, Color, Color) get _colors => switch (role) {
        BridgeRole.creator => (BridgeColors.primaryTint, BridgeColors.primary, BridgeColors.primary),
        BridgeRole.investor => (BridgeColors.investorBg, BridgeColors.investorFg, BridgeColors.primary),
        BridgeRole.collaborator => (BridgeColors.collabBg, BridgeColors.collabFg, BridgeColors.collabFg),
        BridgeRole.buyer => (BridgeColors.buyerBg, BridgeColors.buyerFg, BridgeColors.buyerFg),
      };

  @override
  Widget build(BuildContext context) {
    final (bg, fg, border) = _colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: border.withValues(alpha: 0.4)),
      ),
      child: Text(_label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}

/// Blue check for reviewed posts (Phase 9). Shows only when verified=true.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: BridgeColors.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text('Verified', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
