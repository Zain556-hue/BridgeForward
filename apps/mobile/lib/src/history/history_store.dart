import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One past file. Tap re-shares in 2 taps, no re-make (PRD §8).
class HistoryEntry {
  final String id;
  final String title; // "Video" / "Photo"
  final String subtitle; // "0:32 • 24MB → 18MB"
  final bool isVideo;
  final DateTime date;
  const HistoryEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isVideo,
    required this.date,
  });

  String get group {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = day.difference(d).inDays;
    if (diff <= 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return 'Older';
  }
}

class HistoryStore extends StateNotifier<List<HistoryEntry>> {
  HistoryStore() : super(const []);

  void add(HistoryEntry e) => state = [e, ...state];
  void remove(String id) => state = state.where((e) => e.id != id).toList();
}

final historyProvider = StateNotifierProvider<HistoryStore, List<HistoryEntry>>((_) => HistoryStore());
