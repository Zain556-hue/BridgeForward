import 'package:domain/entities.dart';

/// One file going through pick → prepare → share.
enum JobState { picked, preparing, prepared, shared, saved, failed }

class MediaJobState {
  final String id;
  final String ownerId;
  final MediaKind kind;
  final String originalPath;
  final String? preparedPath;
  final int bytesBefore;
  final int bytesAfter;
  final double progress;
  final JobState state;
  final String? error;

  const MediaJobState({
    required this.id,
    required this.ownerId,
    required this.kind,
    required this.originalPath,
    this.preparedPath,
    this.bytesBefore = 0,
    this.bytesAfter = 0,
    this.progress = 0,
    this.state = JobState.picked,
    this.error,
  });

  MediaJobState copyWith({
    String? preparedPath,
    int? bytesAfter,
    double? progress,
    JobState? state,
    String? error,
  }) =>
      MediaJobState(
        id: id,
        ownerId: ownerId,
        kind: kind,
        originalPath: originalPath,
        preparedPath: preparedPath ?? this.preparedPath,
        bytesBefore: bytesBefore,
        bytesAfter: bytesAfter ?? this.bytesAfter,
        progress: progress ?? this.progress,
        state: state ?? this.state,
        error: error,
      );

  String get stats => bytesAfter > 0 ? '$bytesBefore → $bytesAfter bytes' : '$bytesBefore bytes';
}
