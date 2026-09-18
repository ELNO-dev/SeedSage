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
