import '../discover/discover_store.dart';

/// Tips for you (Phase 9). Same type first, max 3.
/// Real rank model plugs in here after use data grows.
List<Listing> suggestedFor(List<Listing> all, Listing seed, {int max = 3}) {
  final rest = all.where((l) => l.id != seed.id && !l.paused).toList();
  rest.sort((a, b) {
    final sa = a.types.toSet().intersection(seed.types.toSet()).length;
    final sb = b.types.toSet().intersection(seed.types.toSet()).length;
    return sb.compareTo(sa);
  });
  return rest.take(max).toList();
}
