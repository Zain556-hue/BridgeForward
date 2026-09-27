import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/repositories.dart';
import 'package:domain/entities.dart';

/// Offline-first history: local cache is truth for list, net syncs later (Phase 5).
class LocalMediaRepository implements MediaRepository {
  final List<MediaItem> _cache = [];
  @override
  Future<List<MediaItem>> recent(String ownerId, {int limit = 50}) async =>
      _cache.where((m) => m.ownerId == ownerId).take(limit).toList();
  @override
  Future<MediaItem> savePrepared(MediaItem item) async {
    _cache.removeWhere((m) => m.id == item.id);
    _cache.insert(0, item);
    return item;
  }

  @override
  Future<void> remove(String id) async => _cache.removeWhere((m) => m.id == id);
}

final mediaRepositoryProvider = Provider<MediaRepository>((_) => LocalMediaRepository());
