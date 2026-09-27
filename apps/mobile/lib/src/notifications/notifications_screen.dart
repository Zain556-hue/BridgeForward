import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifications_store.dart';

/// Alerts list + on/off switches + quiet hours.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(alertsProvider);
    final prefs = ref.watch(alertPrefsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Keen + asks'),
            value: prefs.keen,
            onChanged: (v) => ref.read(alertPrefsProvider.notifier).state =
                AlertPrefs(keen: v, replies: prefs.replies, quiet: prefs.quiet),
          ),
          SwitchListTile(
            title: const Text('Replies'),
            value: prefs.replies,
            onChanged: (v) => ref.read(alertPrefsProvider.notifier).state =
                AlertPrefs(keen: prefs.keen, replies: v, quiet: prefs.quiet),
          ),
          SwitchListTile(
            title: const Text('Quiet hours (night)'),
            value: prefs.quiet,
            onChanged: (v) => ref.read(alertPrefsProvider.notifier).state =
                AlertPrefs(keen: prefs.keen, replies: prefs.replies, quiet: v),
          ),
          const Divider(),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('No alerts yet.'),
            ),
          for (final a in items)
            Card(
              child: ListTile(
                title: Text(a.title + (a.read ? '' : ' • new')),
                subtitle: Text(a.body),
                onTap: () => ref.read(alertsProvider.notifier).markRead(a.id),
              ),
            ),
        ],
      ),
    );
  }
}
