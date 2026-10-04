class Lot {
  final String lotUuid;
  final String parentObjectUuid;

  const Lot({required this.lotUuid, required this.parentObjectUuid});
}

class LotSummary {
  final String lotUuid;
  final String parentObjectUuid;
  final String? latestEventUuid;
  final String? latestEventTypeUuid;
  final String? latestEventDisplayValue;
  final String? latestEventDate;
  final String? eventIconCode;
  final int lotQuantity;

  const LotSummary({
    required this.lotUuid,
    required this.parentObjectUuid,
    this.latestEventUuid,
    this.latestEventTypeUuid,
    this.latestEventDisplayValue,
    this.latestEventDate,
    this.eventIconCode,
    required this.lotQuantity,
  });
}

class LotHistory {
  final String lotUuid;
  final String parentObjectUuid;
  final String? eventUuid;
  final String? eventTypeUuid;
  final String? eventDisplayValue;
  final String? eventDate;
  final String? eventIconCode;
  final int lotQuantity;

  const LotHistory({
    required this.lotUuid,
    required this.parentObjectUuid,
    this.eventUuid,
    this.eventTypeUuid,
    this.eventDisplayValue,
    this.eventDate,
    this.eventIconCode,
    required this.lotQuantity,
  });
}
