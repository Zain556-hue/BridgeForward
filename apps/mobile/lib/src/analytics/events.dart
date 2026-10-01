/// Count names (PRD §26). One place so all screens spell them same.
abstract final class Events {
  static const mediaPrepared = 'media_prepared';
  static const mediaSharedWhatsapp = 'media_shared_whatsapp';
  static const mediaSaved = 'media_saved';
  static const opportunityCreated = 'opportunity_created';
  static const interestCreated = 'interest_created';
  static const searchUsed = 'search_used';
  static const feedbackSent = 'feedback_sent';
}

/// Tiny sender. PostHog plugs in here (key in .env). Now just prints.
class AnalyticsService {
  static void log(String name, [Map<String, Object?> props = const {}]) {
    // ignore: avoid_print
    print('event=$name props=$props');
  }
}
