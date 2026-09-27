import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../discover/discover_store.dart';

/// My posts: hide/show (pause), delete.
class MyListingsScreen extends ConsumerWidget {
  const MyListingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mine = ref.watch(listingsProvider).where((l) => l.ownerId == 'me').toList();
    return Scaffold(
      appBar: AppBar(title: const Text('My listings')),
      body: mine.isEmpty
          ? const Center(child: Text('You have no posts yet.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final l in mine)
                  Card(
                    child: ListTile(
                      title: Text(l.title + (l.paused ? ' (hidden)' : '')),
                      subtitle: Text(l.stage),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'pause') {
                            ref.read(listingsProvider.notifier).setPaused(l.id, !l.paused);
                          } else {
                            ref.read(listingsProvider.notifier).remove(l.id);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'pause', child: Text('Hide / Show')),
                          PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
