import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Login states. Anonymous first, link later (Phase 3 rule).
enum AuthStatus { anonymous, signedIn }

final authStatusProvider = StateProvider<AuthStatus>((_) => AuthStatus.anonymous);
final displayNameProvider = StateProvider<String>((_) => 'Guest');

class AuthRepository {
  /// Email OTP via Supabase Auth (wired in Phase 5 sync).
  Future<void> sendOtp(String email) async {}
  Future<void> verifyOtp(String email, String code) async {}

  /// Google + Apple sign-in (store builds need client IDs + URL schemes).
  Future<void> signInWithGoogle() async {}
  Future<void> signInWithApple() async {}

  /// Link anonymous cache to account after first Share.
  Future<void> linkAnonymous() async {}
}
