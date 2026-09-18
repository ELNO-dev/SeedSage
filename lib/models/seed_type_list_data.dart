class SeedTypeListQuery {
  final String? statusUuid;
  final String? commonName;
  final String? variant;

  const SeedTypeListQuery({this.statusUuid, this.commonName, this.variant});
}

class SeedTypeListData {
  final String seedTypeUuid;
  final String commonName;
  final String? variant;
  final String? statusUuid;

  const SeedTypeListData({
    required this.seedTypeUuid,
    required this.commonName,
    this.variant,
    this.statusUuid,
  });

  factory SeedTypeListData.fromMap(Map<String, dynamic> map) {
    return SeedTypeListData(
      seedTypeUuid: map['seed_type_object_uuid'] as String,
      commonName: map['common_name'] as String,
      variant: map['variant'] as String?,
      statusUuid: map['status_uuid'] as String?,
    );
  }
}
