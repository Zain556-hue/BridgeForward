import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple counts for "My activity". Local first, net later (Phase 2 plan).
class DashboardCounts {
  final int prepared;
  final int shared;
  final int saved;
  final int views;
  final int interests;
  const DashboardCounts({
    this.prepared = 0,
    this.shared = 0,
    this.saved = 0,
    this.views = 0,
    this.interests = 0,
  });
}

class DashboardStore extends StateNotifier<DashboardCounts> {
  DashboardStore() : super(const DashboardCounts());
  void countPrepared() => state = DashboardCounts(
      prepared: state.prepared + 1, shared: state.shared, saved: state.saved,
      views: state.views, interests: state.interests);
  void countShared() => state = DashboardCounts(
      prepared: state.prepared, shared: state.shared + 1, saved: state.saved,
      views: state.views, interests: state.interests);
  void countSaved() => state = DashboardCounts(
      prepared: state.prepared, shared: state.shared, saved: state.saved + 1,
      views: state.views, interests: state.interests);
}

final dashboardProvider = StateNotifierProvider<DashboardStore, DashboardCounts>((_) => DashboardStore());
