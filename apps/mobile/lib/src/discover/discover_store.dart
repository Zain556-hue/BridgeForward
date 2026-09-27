import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/entities.dart';

/// Thin feed V1: one list + chip filter. No chat, no pay (Phase 6 rule).
class Listing {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String stage;
  final List<OpportunityType> types;
  final bool paused;
  const Listing({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    this.stage = 'idea',
    this.types = const [OpportunityType.collaborator],
    this.paused = false,
  });
}

final listingsProvider = StateNotifierProvider<ListingsStore, List<Listing>>((_) => ListingsStore());
final listingFilterProvider = StateProvider<String>((_) => 'All');

class ListingsStore extends StateNotifier<List<Listing>> {
  ListingsStore() : super(const []);
  void add(Listing l) => state = [l, ...state];
  void setPaused(String id, bool paused) => state = [
        for (final l in state)
          if (l.id == id)
            Listing(id: l.id, ownerId: l.ownerId, title: l.title, description: l.description,
                stage: l.stage, types: l.types, paused: paused)
          else
            l
      ];
  void remove(String id) => state = state.where((l) => l.id != id).toList();
}

const exploreFilters = ['All', 'Investors', 'Collaborators', 'Buyers', 'Projects'];
