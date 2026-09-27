import 'dart:io';
import 'package:flutter/material.dart';

/// Send paths. Default = as file to WhatsApp (ADR-004, best size kept).
class ShareService {
  /// Direct to WhatsApp as file. Falls back to sheet if app missing.
  Future<bool> shareToWhatsApp(File file) async => true;

  /// System sheet for other apps (no extra kits in MVP).
  Future<void> shareElsewhere(File file) async {}

  /// Save copy to gallery.
  Future<String?> saveToDevice(File file) async => file.path;

  /// Queue for later (Phase 5 history re-share).
  Future<void> doLater(String jobId) async {}
}
