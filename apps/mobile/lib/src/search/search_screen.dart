import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../discover/discover_store.dart';
import '../opps/opportunity_detail_screen.dart';

/// Find posts + people. Waits 300ms after typing (no spam).
/// Net FTS (search_tsv) plugs in here in Phase 8; local filter now.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});
  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Timer? _wait;
  String _q = '';
  final _recent = <String>[];

  void _onType(String v) {
    _wait?.cancel();
    _wait = Timer(const Duration(milliseconds: 300), () => setState(() => _q = v.trim()));
  }

  @override
  void dispose() {
    _wait?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(listingsProvider);
    final q = _q.toLowerCase();
    final hits = q.isEmpty
        ? const <Listing>[]
        : all.where((l) => '${l.title} ${l.description}'.toLowerCase().contains(q)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BridgeSearchBar(onChanged: _onType),
          if (_recent.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [for (final r in _recent) Chip(label: Text(r))],
            ),
          ],
          const SizedBox(height: 8),
          for (final l in hits)
            Card(
              child: ListTile(
                title: Text(l.title),
                subtitle: Text(l.stage),
                onTap: () {
                  setState(() {
                    _recent.remove(_q);
                    _recent.insert(0, _q);
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => OpportunityDetailScreen(listing: l)));
                },
              ),
            ),
          if (q.isNotEmpty && hits.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text('Nothing found. Try another word.',
                  style: TextStyle(color: BridgeColors.muted)),
            ),
        ],
      ),
    );
  }
}
