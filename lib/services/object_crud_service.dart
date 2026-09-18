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
}
