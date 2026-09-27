import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:domain/entities.dart';
import '../discover/discover_store.dart';

/// New post form: title, what, problem, who, stage, needs, type boxes.
/// No phone/email shown — app-only contact (trust rule).
class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});
  @override
  ConsumerState<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _need = TextEditingController();
  String _stage = 'idea';
  final _types = <OpportunityType>{OpportunityType.collaborator};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New listing')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          BridgeTextField(hint: 'Title', controller: _title),
          const SizedBox(height: 8),
          BridgeTextField(hint: 'What is it?', controller: _desc),
          const SizedBox(height: 8),
          BridgeTextField(hint: 'What do you need?', controller: _need),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _stage,
            items: const [
              DropdownMenuItem(value: 'idea', child: Text('Idea')),
              DropdownMenuItem(value: 'mvp', child: Text('MVP')),
              DropdownMenuItem(value: 'growth', child: Text('Growth')),
            ],
            onChanged: (v) => setState(() => _stage = v ?? 'idea'),
            decoration: const InputDecoration(labelText: 'Stage'),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final t in OpportunityType.values)
                FilterChip(
                  label: Text(t.name),
                  selected: _types.contains(t),
                  onSelected: (s) => setState(() => s ? _types.add(t) : _types.remove(t)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          BridgePrimaryButton(
            label: 'Post',
            onPressed: () {
              if (_title.text.trim().isEmpty) return;
              ref.read(listingsProvider.notifier).add(Listing(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    ownerId: 'me',
                    title: _title.text.trim(),
                    description: _desc.text.trim(),
                    stage: _stage,
                    types: _types.toList(),
                  ));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
