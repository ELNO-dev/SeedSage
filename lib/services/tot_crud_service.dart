import 'package:supabase_flutter/supabase_flutter.dart';

class TotCrudService {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<void> createTotObj(String objectUuid, String totDefUuid, int totValue) async {
    await _supabase.from('tot_obj').insert({
      'object_uuid': objectUuid,
      'total_definition_uuid': totDefUuid,
      'total_value': totValue,
    });
  }

  Future<void> updateTotObj(String objectUuid, String totDefUuid, int totValue) async {
    await _supabase
        .from('tot_obj')
        .update({'total_value': totValue})
        .eq('object_uuid', objectUuid)
        .eq('total_definition_uuid', totDefUuid);
  }

  Future<int> getTotObj(String objectUuid, String totDefUuid, int totValue) async {
    final response = await _supabase
        .from('tot_obj')
        .select('total_value')
        .eq('object_uuid', objectUuid)
        .eq('total_definition_uuid', totDefUuid)
        .single();

    return response['total_value'] as int;
  }
}
// DELETE RULE:
// 1. obj_object deletion cascades to records dependent on that object.
// 2. Database cascade never deletes another obj_object.
// 3. Child obj_object records are explicitly deleted by the process service.
// 4. Deletion never cascades upward to a parent.