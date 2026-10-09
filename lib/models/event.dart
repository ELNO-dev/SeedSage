class EventHistoryView {
  final String objectUuid;
  final DateTime eventDate;
  final String eventTypeUuid;
  final String eventTypeCode;
  final String eventUuid;
  final String eventTypeName;
  final String masterDataTypeUuid;
  final String eventCode;
  final String eventDisplayValue;
  final int? eventDisplaySequence;
  final String? iconCode;

  const EventHistoryView({
    required this.objectUuid,
    required this.eventDate,
    required this.eventTypeUuid,
    required this.eventTypeCode,
    required this.eventUuid,
    required this.eventTypeName,
    required this.masterDataTypeUuid,
    required this.eventCode,
    required this.eventDisplayValue,
    this.eventDisplaySequence,
    this.iconCode,
  });
}
