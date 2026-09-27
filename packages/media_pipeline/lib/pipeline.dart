// pick() -> validate() -> analyze() -> plan() -> execute() -> preview() -> save/share() -> log()
abstract class MediaJob {
  String get id;
  Future<void> execute({void Function(double progress)? onProgress});
  Future<void> cancel();
}
