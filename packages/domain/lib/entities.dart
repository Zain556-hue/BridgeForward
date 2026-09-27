// Domain entities mirror supabase/migrations/0001_init.sql
enum MediaKind { photo, video }
enum MediaStatus { picked, preparing, prepared, shared, saved, failed }
enum OpportunityType { investor, collaborator, buyer, partner }
enum InterestKind { interested, connect, collabRequest, infoRequest }

class MediaItem {
  final String id, ownerId;
  final MediaKind kind;
  final int bytesBefore, bytesAfter;
  final MediaStatus status;
  const MediaItem({required this.id, required this.ownerId, required this.kind,
    required this.bytesBefore, required this.bytesAfter, required this.status});
}

class Opportunity {
  final String id, ownerId, title, description;
  final List<OpportunityType> types;
  const Opportunity({required this.id, required this.ownerId, required this.title,
    required this.description, required this.types});
}
