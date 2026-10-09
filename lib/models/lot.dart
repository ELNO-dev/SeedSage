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
  final int remainingQuantity;

  const LotSummary({
    required this.lotUuid,
    required this.parentObjectUuid,
    this.latestEventUuid,
    this.latestEventTypeUuid,
    this.latestEventDisplayValue,
    this.latestEventDate,
    this.eventIconCode,
    required this.lotQuantity,
    required this.remainingQuantity,
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
  final int remainingQuantity;
  final int? displaySequence;

  const LotHistory({
    required this.lotUuid,
    required this.parentObjectUuid,
    this.eventUuid,
    this.eventTypeUuid,
    this.eventDisplayValue,
    this.eventDate,
    this.eventIconCode,
    required this.lotQuantity,
    required this.remainingQuantity,
    this.displaySequence,
  });
}
