import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Buckets: originals (private), prepared (private), avatars (public), thumbs (public).
/// Create once via dashboard or storage API; RLS keeps media owner-only.
class ShareRequest {
  final File file;
  final bool directWhatsapp;
  const ShareRequest(this.file, {this.directWhatsapp = true});
}

/// Android: ACTION_SEND + FileProvider URI, setPackage com.whatsapp, else chooser.
/// iOS: UIActivityViewController. "Elsewhere" = system sheet (ADR-004).
final shareRequestProvider = StateProvider<ShareRequest?>((_) => null);
