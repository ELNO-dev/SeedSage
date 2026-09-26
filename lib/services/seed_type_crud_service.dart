import 'package:seedsage/models/seed_type.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeedTypeService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Delete a seed type based on a submitted UUID
  Future<void> deleteSeedType(String seedTypeUuid) async {
    await _supabase.from('obj_seed_type').delete().eq('seed_type_object_uuid', seedTypeUuid);
  }

  // Create a seed type using submitted attributes
  Future<void> createSeedType(SeedType seedType) async {
    await _supabase.from('obj_seed_type').insert({
      'seed_type_object_uuid': seedType.seedTypeObjectUuid,
      'common_name': seedType.commonName,
      'variant': seedType.variant,
      'botanical_name': seedType.botanicalName,
      'description': seedType.description,
      'min_germination_temperature_c': seedType.minGerminationTemperatureC,
      'max_germination_temperature_c': seedType.maxGerminationTemperatureC,
      'growing_instructions': seedType.growingInstructions,
      'min_height_cm': seedType.minHeightCm,
      'max_height_cm': seedType.maxHeightCm,
      'min_spacing_cm': seedType.minSpacingCm,
      'max_spacing_cm': seedType.maxSpacingCm,
      'stratification_required': seedType.stratificationRequired,
      'pinching_required': seedType.pinchingRequired,
      'min_germination_days': seedType.minGerminationDays,
      'max_germination_days': seedType.maxGerminationDays,
      'min_transplant_days': seedType.minTransplantDays,
      'max_transplant_days': seedType.maxTransplantDays,
      'min_flower_fruit_days': seedType.minFlowerFruitDays,
      'max_flower_fruit_days': seedType.maxFlowerFruitDays,
      'life_cycle_uuid': seedType.lifeCycleUuid,
    });

    if (seedType.imageId != null) {
      try {
        await _supabase.from('img_object_link').insert({
          'image_object_uuid': seedType.imageId,
          'object_uuid': seedType.seedTypeObjectUuid,
        });
      } catch (e) {
        rethrow;
      }
    }
  }

  // Update a seed type using submitted attributes based on the seed type UUID
  Future<void> updateSeedType(SeedType seedType) async {
    await _supabase
        .from('obj_seed_type')
        .update({
          'common_name': seedType.commonName,
          'variant': seedType.variant,
          'botanical_name': seedType.botanicalName,
          'description': seedType.description,
          'min_germination_temperature_c': seedType.minGerminationTemperatureC,
          'max_germination_temperature_c': seedType.maxGerminationTemperatureC,
          'growing_instructions': seedType.growingInstructions,
          'min_height_cm': seedType.minHeightCm,
          'max_height_cm': seedType.maxHeightCm,
          'min_spacing_cm': seedType.minSpacingCm,
          'max_spacing_cm': seedType.maxSpacingCm,
          'stratification_required': seedType.stratificationRequired,
          'pinching_required': seedType.pinchingRequired,
          'min_germination_days': seedType.minGerminationDays,
          'max_germination_days': seedType.maxGerminationDays,
          'min_transplant_days': seedType.minTransplantDays,
          'max_transplant_days': seedType.maxTransplantDays,
          'min_flower_fruit_days': seedType.minFlowerFruitDays,
          'max_flower_fruit_days': seedType.maxFlowerFruitDays,
          'life_cycle_uuid': seedType.lifeCycleUuid,
          'image_id': seedType.imageId,
        })
        .eq('seed_type_object_uuid', seedType.seedTypeObjectUuid);
  }

  Future<SeedType> readSeedTypeDetail(String seedTypeUuid) async {
    final result = await _supabase
        .from('obj_seed_type')
        .select()
        .eq('seed_type_object_uuid', seedTypeUuid)
        .maybeSingle();

    final seedType = SeedType(
      seedTypeObjectUuid: seedTypeUuid,
      commonName: result?['common_name'] ?? '',
      variant: result?['variant'],
      botanicalName: result?['botanical_name'],
      description: result?['description'],
      minGerminationTemperatureC: result?['min_germination_temperature_c'],
      maxGerminationTemperatureC: result?['max_germination_temperature_c'],
      growingInstructions: result?['growing_instructions'],
      stratificationRequired: result?['stratification_required'],
      pinchingRequired: result?['pinching_required'],
      minHeightCm: result?['min_height_cm'],
      maxHeightCm: result?['max_height_cm'],
      minSpacingCm: result?['min_spacing_cm'],
      maxSpacingCm: result?['max_spacing_cm'],
      minGerminationDays: result?['min_germination_days'],
      maxGerminationDays: result?['max_germination_days'],
      minTransplantDays: result?['min_transplant_days'],
      maxTransplantDays: result?['max_transplant_days'],
      minFlowerFruitDays: result?['min_flower_fruit_days'],
      maxFlowerFruitDays: result?['max_flower_fruit_days'],
      lifeCycleUuid: result?['life_cycle_uuid'],
      imageId: null,
    );
    return seedType;
  }
}
