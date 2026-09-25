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
