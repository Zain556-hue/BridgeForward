import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'history_store.dart';
import '../media/preview_screen.dart';

/// Recent list in groups Today / Yesterday / Older.
/// Tap = re-share view. Swipe = delete. Survives restart in Phase 8 (local DB).
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(historyProvider);
    if (items.isEmpty) {
      return const SafeArea(
        child: Center(child: Text('No files yet.\nPick one from Home.')),
      );
    }
    final groups = <String, List<HistoryEntry>>{};
    for (final e in items) {
      groups.putIfAbsent(e.group, () => []).add(e);
    }
    const order = ['Today', 'Yesterday', 'Older'];
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          for (final g in order)
            if (groups.containsKey(g)) ...[
              Text(g, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              for (final e in groups[g]!)
                Dismissible(
                  key: ValueKey(e.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => ref.read(historyProvider.notifier).remove(e.id),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: BridgeColors.danger, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PreviewScreen())),
                    child: MediaCard(title: '${e.title} — ${e.group}', subtitle: e.subtitle, isVideo: e.isVideo),
                  ),
                ),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }
}
