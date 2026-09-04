class SeedType {
  final String seedTypeObjectUuid;
  final String commonName;
  final String? variant;
  final String? botanicalName;
  final String? description;
  final String? growingInstructions;
  final int? minGerminationTemperatureC;
  final int? maxGerminationTemperatureC;
  final int? minHeightCm;
  final int? maxHeightCm;
  final int? minSpacingCm;
  final int? maxSpacingCm;
  final String? lifeCycleUuid;
  final String? seedGroupingUuid;
  final bool? stratificationRequired;
  final int? minGerminationDays;
  final int? maxGerminationDays;
  final int? minTransplantDays;
  final int? maxTransplantDays;
  final int? minFlowerFruitDays;
  final int? maxFlowerFruitDays;
  final bool? pinchingRequired;
  final String? imageId;

  const SeedType({
    required this.seedTypeObjectUuid,
    required this.commonName,
    required this.variant,
    required this.botanicalName,
    required this.description,
    required this.growingInstructions,
    required this.minGerminationTemperatureC,
    required this.maxGerminationTemperatureC,
    required this.minHeightCm,
    required this.maxHeightCm,
    required this.minSpacingCm,
    required this.maxSpacingCm,
    required this.lifeCycleUuid,
    required this.seedGroupingUuid,
    required this.stratificationRequired,
    required this.minGerminationDays,
    required this.maxGerminationDays,
    required this.minTransplantDays,
    required this.maxTransplantDays,
    required this.minFlowerFruitDays,
    required this.maxFlowerFruitDays,
    required this.pinchingRequired,
    required this.imageId,
  });
}
