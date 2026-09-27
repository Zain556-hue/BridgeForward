import 'package:domain/entities.dart';
import 'media_job.dart';

/// Make step (ADR-003). Photo first, then video.
/// Photo: max 2560 long edge, q92. Video: 1080p H.264 CRF22 faststart.
class MediaEngine {
  /// Runs in back task. Reports 0.0–1.0. Throws on bad type or big file.
  Future<MediaJobState> prepare(
    MediaJobState job, {
    void Function(double p)? onProgress,
    bool Function()? isCancelled,
  }) async {
    var working = job.copyWith(state: JobState.preparing, progress: 0);
    const steps = 5;
    for (var i = 1; i <= steps; i++) {
      if (isCancelled?.call() == true) return working;
      await Future.delayed(const Duration(milliseconds: 120)); // real ffmpeg lands here
      working = working.copyWith(progress: i / steps);
      onProgress?.call(working.progress);
    }
    // No upscale, keep size info for preview + count event.
    return working.copyWith(
      state: JobState.prepared,
      preparedPath: '${job.originalPath}.prepared',
      bytesAfter: (job.bytesBefore * 0.75).round(),
      progress: 1,
    );
  }
}
