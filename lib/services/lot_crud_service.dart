import 'package:supabase_flutter/supabase_flutter.dart';

class LotCrudService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createLotFromParent(String parentObjectUuid, String lotUuid) async {
    await _supabase
        .from('lot_object')
        .insert({'parent_object_uuid': parentObjectUuid, 'lot_uuid': lotUuid})
        .select('lot_uuid')
        .single();
  }
}
