import 'package:supabase_flutter/supabase_flutter.dart';

class LotCrudService {
  final SupabaseClient _supabase = Supabase.instance.client;
  // Create Lot from parent uuid
  Future<void> createLotFromParent(String parentObjectUuid, String lotUuid) async {
    await _supabase
        .from('lot_object')
        .insert({'parent_object_uuid': parentObjectUuid, 'lot_uuid': lotUuid})
        .select('lot_uuid')
        .single();
  }

  // DELETE RULE:
  // 1. obj_object deletion cascades to records dependent on that object.
  // 2. Database cascade never deletes another obj_object.
  // 3. Child obj_object records are explicitly deleted by the process service.
  // 4. Deletion never cascades upward to a parent.
  Future<void> deleteSeedType(String seedTypeUuid) async {
    await _supabase.from('obj_seed_type').delete().eq('seed_type_object_uuid', seedTypeUuid);
  }

  // Get lots from packets
  Future<List<String>> getLotObjectUuidsBySeedPackets(List<String> seedPacketUuids) async {
    final response = await _supabase
        .from('lot_object')
        .select('lot_uuid')
        .inFilter('parent_object_uuid', seedPacketUuids);

    return response.map<String>((row) => row['lot_uuid'] as String).toList();
  }
}
