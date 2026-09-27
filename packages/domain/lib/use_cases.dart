import 'package:domain/entities.dart';
import 'package:domain/repositories.dart';

/// Rules for "Prepare" step: what we keep vs shrink (ADR-003).
class PreparePlan {
  final int? maxLongEdge; // photos
  final int quality; // 0-100
  final bool transcode; // videos
  const PreparePlan({this.maxLongEdge = 2560, this.quality = 92, this.transcode = false});
}

class PrepareMediaUseCase {
  final MediaRepository repo;
  const PrepareMediaUseCase(this.repo);

  PreparePlan planFor(MediaKind kind) => switch (kind) {
        MediaKind.photo => const PreparePlan(maxLongEdge: 2560, quality: 92),
        MediaKind.video => const PreparePlan(transcode: true),
      };
}
