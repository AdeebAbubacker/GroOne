import 'package:gro_one_app/data/model/serializable.dart';

/// Source information for event tracking
class EventSource {
  final String platform;
  final String appVersion;
  final String deviceId;
  final String ip;

  const EventSource({
    required this.platform,
    required this.appVersion,
    required this.deviceId,
    required this.ip,
  });

  Map<String, dynamic> toJson() => {
    "platform": platform,
    "app_version": appVersion,
    "device_id": deviceId,
    "ip": ip,
  };
}

/// Context information for event
class EventContext {
  final String viewd;

  const EventContext({
    required this.viewd,
  });

  Map<String, dynamic> toJson() => {
    "viewd": viewd,
  };
}

/// Create Event API Request Model
class CreateEventApiRequest extends Serializable<CreateEventApiRequest> {
  final String customerUuid;
  final String entity;
  final String subEntity;
  final String entityId;
  final String stage;
  final EventContext context;
  final EventSource source;

   CreateEventApiRequest({
    required this.customerUuid,
    required this.entity,
    required this.subEntity,
    required this.entityId,
    required this.stage,
    required this.context,
    required this.source,
  });

  @override
  Map<String, dynamic> toJson() => {
    "customer_uuid": customerUuid,
    "entity": entity,
    "sub_entity": subEntity,
    "entity_id": entityId,
    "stage": stage,
    "context": context.toJson(),
    "source": source.toJson(),
  };

  CreateEventApiRequest copyWith({
    String? customerUuid,
    String? entity,
    String? subEntity,
    String? entityId,
    String? stage,
    EventContext? context,
    EventSource? source,
  }) {
    return CreateEventApiRequest(
      customerUuid: customerUuid ?? this.customerUuid,
      entity: entity ?? this.entity,
      subEntity: subEntity ?? this.subEntity,
      entityId: entityId ?? this.entityId,
      stage: stage ?? this.stage,
      context: context ?? this.context,
      source: source ?? this.source,
    );
  }
}
