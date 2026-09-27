import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'discover_store.dart';
import '../opps/create_listing_screen.dart';
import '../opps/opportunity_detail_screen.dart';

/// Explore: one feed + chips. Cards show title + needs. Tap opens detail.
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(listingFilterProvider);
    final all = ref.watch(listingsProvider);
    final items = filter == 'All' ? all : all.where((l) => l.title.isNotEmpty).toList();
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (final f in exploreFilters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: filter == f,
                      onSelected: (_) => ref.read(listingFilterProvider.notifier).state = f,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No posts yet.\nBe the first to add one.'))
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final l in items)
                        Card(
                          child: ListTile(
                            title: Text(l.title),
                            subtitle: Text('${l.stage} • ${l.description}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => OpportunityDetailScreen(listing: l))),
                          ),
                        ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: BridgePrimaryButton(
              label: 'New listing',
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CreateListingScreen())),
            ),
          ),
        ],
      ),
    );
  }
}
