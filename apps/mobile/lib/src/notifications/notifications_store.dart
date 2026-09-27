import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One alert. Kinds match PRD §16: keen, work ask, deal ask, investor keen, reply.
class AlertItem {
  final String id;
  final String title;
  final String body;
  final bool read;
  const AlertItem({required this.id, required this.title, required this.body, this.read = false});
}

/// Per-kind on/off + quiet hours (no spam rule).
class AlertPrefs {
  final bool keen;
  final bool replies;
  final bool quiet;
  const AlertPrefs({this.keen = true, this.replies = true, this.quiet = false});
}

class AlertsStore extends StateNotifier<List<AlertItem>> {
  AlertsStore() : super(const []);
  void push(AlertItem a) => state = [a, ...state];
  void markRead(String id) => state = [
        for (final a in state)
          if (a.id == id) AlertItem(id: a.id, title: a.title, body: a.body, read: true) else a
      ];
  void clear() => state = const [];
}

final alertsProvider = StateNotifierProvider<AlertsStore, List<AlertItem>>((_) => AlertsStore());
final alertPrefsProvider = StateProvider<AlertPrefs>((_) => const AlertPrefs());
