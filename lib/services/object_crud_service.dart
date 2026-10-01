import 'package:supabase_flutter/supabase_flutter.dart';

class ObjectCrudService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> createObjectfromType(String objectTypeUuid) async {
    final response = await _supabase
        .from('obj_object')
        .insert({'object_type_uuid': objectTypeUuid})
        .select('object_uuid')
        .single();
    final objectUuid = response['object_uuid'];
    return objectUuid;
  }

  // DELETE RULE:
  // 1. obj_object deletion cascades to records dependent on that object.
  // 2. Database cascade never deletes another obj_object.
  // 3. Child obj_object records are explicitly deleted by the process service.
  // 4. Deletion never cascades upward to a parent.

  Future<void> deleteObject(String objectUuid) async {
    await _supabase.from('obj_object').delete().eq('object_uuid', objectUuid);
  }
}
