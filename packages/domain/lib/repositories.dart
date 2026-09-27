import 'entities.dart';

// All data access goes through these names.
// UI uses use-cases, use-cases use these. Swap backend without UI change (ADR-002).

abstract class MediaRepository {
  Future<List<MediaItem>> recent(String ownerId, {int limit = 50});
  Future<MediaItem> savePrepared(MediaItem item);
  Future<void> remove(String id);
}

abstract class OpportunityRepository {
  Future<List<Opportunity>> explore({String? query, String? filter});
  Future<Opportunity> create(Opportunity opp);
  Future<void> setPaused(String id, bool paused);
}

abstract class InterestRepository {
  /// Express interest / connect / request collab / request info (no phone/email leak).
  Future<void> express({required String opportunityId, required String actorId, required InterestKind kind, String? message});
  Future<List<Map<String, dynamic>>> forOwner(String ownerId);
}

abstract class ActivityRepository {
  Future<Map<String, int>> counts(String ownerId);
}
