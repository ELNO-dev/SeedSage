import 'package:supabase_flutter/supabase_flutter.dart';

class EvtObjCrudService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createEvtObj(String objectUuid, String objectStatusUuid) async {
    await _supabase.from('evt_obj').insert({
      'object_uuid': objectUuid,
      'event_type_uuid': objectStatusUuid,
      'event_date': DateTime.now().toIso8601String(),
    });
  }
}
// DELETE RULE:
// 1. obj_object deletion cascades to records dependent on that object.
// 2. Database cascade never deletes another obj_object.
// 3. Child obj_object records are explicitly deleted by the process service.
// 4. Deletion never cascades upward to a parent.