import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seedsage/seed_sage.dart';

class EvtObjCrudService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> createEvtObj(String objectUuid, String objectStatusUuid) async {
    await _supabase.from('evt_obj').insert({
      'object_uuid': objectUuid,
      'event_type_uuid': objectStatusUuid,
      'event_date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> createEvtObjwithDate(String objectUuid, String objectStatusUuid, DateTime eventDate) async {
    await _supabase.from('evt_obj').insert({
      'object_uuid': objectUuid,
      'event_type_uuid': objectStatusUuid,
      'event_date': eventDate.toIso8601String().split('T').first,
    });
  }

  Future<EventHistoryView> getHighestEventByDisplaySequence(String objectUuid, String masterDataTypeUuid) async {
    final response = await _supabase
        .from('vw_event_history')
        .select()
        .eq('master_data_type_uuid', masterDataTypeUuid)
        .eq('object_uuid', objectUuid)
        .order('display_sequence', ascending: false)
        .limit(1)
        .single();

    final eventHistoryView = EventHistoryView(
      objectUuid: response['object_uuid'],
      eventDate: DateTime.parse(response['event_date']),
      eventTypeUuid: response['event_type_uuid'],
      eventTypeCode: response['event_type_code'],
      eventUuid: response['event_uuid'],
      eventTypeName: response['event_type_name'],
      masterDataTypeUuid: response['master_data_type_uuid'],
      eventCode: response['event_code'],
      eventDisplayValue: response['event_display_value'],
      eventDisplaySequence: response['display_sequence'],
      iconCode: response['icon_code'],
    );
    return eventHistoryView;
  }
}

// DELETE RULE:
// 1. obj_object deletion cascades to records dependent on that object.
// 2. Database cascade never deletes another obj_object.
// 3. Child obj_object records are explicitly deleted by the process service.
// 4. Deletion never cascades upward to a parent.
