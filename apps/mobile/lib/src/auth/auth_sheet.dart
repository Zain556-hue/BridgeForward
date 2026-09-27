import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'auth_repository.dart';

/// Login sheet: OTP + Google + Apple. Shown only when sync needed.
class AuthSheet extends ConsumerStatefulWidget {
  const AuthSheet({super.key});
  @override
  ConsumerState<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<AuthSheet> {
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Save across devices?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Login only for sync. Try first, login later.',
              style: TextStyle(color: BridgeColors.muted)),
          const SizedBox(height: 12),
          BridgeTextField(hint: 'Email for code', controller: _email),
          const SizedBox(height: 8),
          BridgePrimaryButton(label: 'Send code', onPressed: () {}),
          BridgeSecondaryButton(label: 'Continue with Google', onPressed: () {}),
          BridgeTertiaryButton(label: 'Continue with Apple', onPressed: () {}),
        ],
      ),
    );
  }
}
