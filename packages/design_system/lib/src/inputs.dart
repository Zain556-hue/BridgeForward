import 'package:flutter/material.dart';
import 'tokens.dart';

/// Text input + search bar with sharp 1px borders.
class BridgeTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  const BridgeTextField({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minHeight: 48,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: BridgeColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BridgeRadii.sm),
          borderSide: const BorderSide(color: BridgeColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(BridgeRadii.sm),
          borderSide: const BorderSide(color: BridgeColors.line),
        ),
      ),
    );
  }
}

class BridgeSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  const BridgeSearchBar({super.key, this.hint = 'Search opportunities, people…', this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint,
      onChanged: onChanged,
      backgroundColor: const WidgetStatePropertyAll(BridgeColors.paper),
      side: const WidgetStatePropertyAll(BorderSide(color: BridgeColors.line)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(BridgeRadii.sm))),
      leading: const Icon(Icons.search, color: BridgeColors.muted),
    );
  }
}
