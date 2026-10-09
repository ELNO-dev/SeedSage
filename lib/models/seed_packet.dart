class SeedPacket {
  final String seedPacketObjectUuid;
  final String seedTypeUuid;
  final String? source;
  final DateTime? purchaseDate;
  final int? initialSeedQuantity;

  const SeedPacket({
    required this.seedPacketObjectUuid,
    required this.seedTypeUuid,
    this.source,
    this.purchaseDate,
    this.initialSeedQuantity,
  });
}

class SeedPacketSummary {
  final String seedPacketObjectUuid;
  final String seedTypeUuid;
  final String? source;
  final DateTime? purchaseDate;
  final int? initialSeedQuantity;
  final int? remainingQuantity;
  final String latestEventUuid;
  final String latestEventTypeUuid;
  final String latestEventDisplayValue;
  final String latestEventIconCode;
  final DateTime latestEventDate;
  final int? latestEventDispaySequence;

  const SeedPacketSummary({
    required this.seedPacketObjectUuid,
    required this.seedTypeUuid,
    this.source,
    this.purchaseDate,
    this.initialSeedQuantity,
    this.remainingQuantity,
    required this.latestEventUuid,
    required this.latestEventTypeUuid,
    required this.latestEventDisplayValue,
    this.latestEventDispaySequence,
    required this.latestEventDate,
    required this.latestEventIconCode,
  });
}
