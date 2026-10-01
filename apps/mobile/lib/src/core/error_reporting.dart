import 'package:flutter/material.dart';

/// Crash + slow guard. Sentry plugs in here (key in .env).
/// Goal: crash-free > 99.5%, cold start < 2s.
class ErrorGuard {
  static Future<void> init() async {
    FlutterError.onError = (details) {
      // ignore: avoid_print
      print('error: ${details.exception}');
    };
  }

  static void hit(String name, int ms) {
    // ignore: avoid_print
    print('perf=$name ${ms}ms');
  }
}
