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
}
