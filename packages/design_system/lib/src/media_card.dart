import 'package:flutter/material.dart';
import 'tokens.dart';

/// Card for Recent Media (PRD §8): thumb + "Today / Yesterday" + size info.
class MediaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isVideo;
  const MediaCard({super.key, required this.title, required this.subtitle, this.isVideo = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: BridgeColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BridgeRadii.sm),
        side: const BorderSide(color: BridgeColors.line),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: isVideo
                  ? [BridgeColors.primary, BridgeColors.accent]
                  : [BridgeColors.primaryDark, BridgeColors.primary],
            ),
          ),
          child: Icon(isVideo ? Icons.play_arrow_rounded : Icons.image_rounded, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(color: BridgeColors.muted, fontSize: 14)),
      ),
    );
  }
}

/// One row in History list. Tap re-shares without re-prepare (Phase 5).
class HistoryRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const HistoryRow({super.key, required this.title, required this.subtitle, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(title + subtitle),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: BridgeColors.danger, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: MediaCard(title: title, subtitle: subtitle),
    );
  }
}
