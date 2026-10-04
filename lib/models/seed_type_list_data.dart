class SeedTypeListQuery {
  final String? eventUuid;
  final String? commonName;
  final String? variant;

  const SeedTypeListQuery({this.eventUuid, this.commonName, this.variant});
}

class SeedTypeListData {
  final String seedTypeUuid;
  final String commonName;
  final String? variant;
  final String? eventUuid;

  const SeedTypeListData({required this.seedTypeUuid, required this.commonName, this.variant, this.eventUuid});

  factory SeedTypeListData.fromMap(Map<String, dynamic> map) {
    return SeedTypeListData(
      seedTypeUuid: map['seed_type_object_uuid'] as String,
      commonName: map['common_name'] as String,
      variant: map['variant'] as String?,
      eventUuid: map['event_uuid'] as String?,
    );
  }
}
