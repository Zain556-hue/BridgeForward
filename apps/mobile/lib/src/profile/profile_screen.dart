import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import '../auth/auth_repository.dart';
import '../auth/auth_sheet.dart';
import 'settings_screen.dart';

/// Profile (PRD §9): name, photo, tabs as placeholders to later phases.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(displayNameProvider);
    final status = ref.watch(authStatusProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 28, backgroundColor: BridgeColors.primaryTint,
                  child: Icon(Icons.person, color: BridgeColors.primaryDark)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    Text(status == AuthStatus.anonymous ? 'Guest — login for sync' : 'Signed in',
                        style: const TextStyle(color: BridgeColors.muted)),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Wrap(spacing: 6, runSpacing: 6, children: [
            RoleBadge(role: BridgeRole.creator),
          ]),
          const SizedBox(height: 16),
          BridgeSecondaryButton(
            label: status == AuthStatus.anonymous ? 'Login / Sync' : 'Account',
            onPressed: () => showModalBottomSheet(
                context: context, builder: (_) => const AuthSheet()),
          ),
        ],
      ),
    );
  }
}
