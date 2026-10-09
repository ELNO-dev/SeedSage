import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seedsage/seed_sage.dart';

class LotCrudService {
  final SupabaseClient _supabase = Supabase.instance.client;
  // Create Lot from parent uuid
  Future<void> createLotFromParent(String parentObjectUuid, String lotUuid, String seedPacketUuid) async {
    await _supabase
        .from('lot_object')
        .insert({'parent_object_uuid': parentObjectUuid, 'lot_uuid': lotUuid, 'seed_packet_uuid': seedPacketUuid})
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

  // Get lots from packet
  Future<List<Lot>> getLotObjectUuidsBySeedPacket(String seedPacketUuid) async {
    final response = await _supabase.from('lot_object').select().eq('parent_object_uuid', seedPacketUuid);

    return response.map<Lot>((lot) {
      return Lot(parentObjectUuid: lot['parent_object_uuid'], lotUuid: lot['lot_uuid']);
    }).toList();
  }

  // Get lot summariess from packet
  Future<List<LotSummary>> getLotSummariesSeedPacket(String seedPacketUuid) async {
    final response = await _supabase.from('vw_lot_summary').select().eq('parent_object_uuid', seedPacketUuid);

    return response.map<LotSummary>((lotsummary) {
      return LotSummary(
        parentObjectUuid: lotsummary['parent_object_uuid'],
        lotUuid: lotsummary['lot_uuid'],
        latestEventDate: lotsummary['latest_event_date'],
        latestEventDisplayValue: lotsummary['latest_event_display_value'],
        latestEventTypeUuid: lotsummary['latest_event_type_uuid'],
        latestEventUuid: lotsummary['latest_event_uuid'],
        eventIconCode: lotsummary['latest_event_icon_code'],
        lotQuantity: lotsummary['total_seeds'],
        remainingQuantity: lotsummary['remaining_seeds'],
      );
    }).toList();
  }

  // Get lot history from lotUuid list
  Future<List<LotHistory>> getLotHistoryLotUuidList(List<String> lotUuids) async {
    final response = await _supabase.from('vw_lot_history').select().inFilter('lot_uuid', lotUuids);

    return response.map<LotHistory>((lotHistory) {
      return LotHistory(
        parentObjectUuid: lotHistory['parent_object_uuid'],
        lotUuid: lotHistory['lot_uuid'],
        eventDate: lotHistory['event_date'],
        eventDisplayValue: lotHistory['event_display_value'],
        eventTypeUuid: lotHistory['event_type_uuid'],
        eventUuid: lotHistory['event_uuid'],
        eventIconCode: lotHistory['event_icon_code'],
        lotQuantity: lotHistory['lot_quantity'],
        remainingQuantity: lotHistory['lot_remaining_quantity'],
        displaySequence: lotHistory['event_display_sequence'],
      );
    }).toList();
  }

  // Get lots from parent
  // Get lot from lot UUID
  Future<Lot> getLotObjectFromUuid(String lotUuid) async {
    final response = await _supabase.from('lot_object').select().eq('lot_uuid', lotUuid).single();

    return Lot(parentObjectUuid: response['parent_object_uuid'], lotUuid: response['lot_uuid']);
  }

  // Get 1 lot data
  Future<LotHistory> getLotFromHistory(String lotUuid) async {
    final response = await _supabase.from('vw_lot_history').select().eq('lot_uuid', lotUuid).single();
    return LotHistory(
      parentObjectUuid: response['parent_object_uuid'],
      lotUuid: response['lot_uuid'],
      eventDate: response['event_date'],
      eventDisplayValue: response['event_display_value'],
      eventTypeUuid: response['event_type_uuid'],
      eventUuid: response['event_uuid'],
      eventIconCode: response['event_icon_code'],
      lotQuantity: response['lot_quantity'],
      remainingQuantity: response['lot_remaining_quantity'],
    );
  }

  // Get latest lot based on latest event date
  // Get latest lot from seed packet - straight line only
  Future<LotSummary?> getLatestLotSummarySeedPacket(String seedPacketUuid) async {
    String parentUuid = seedPacketUuid;
    Map<String, dynamic>? latestLot;

    while (true) {
      final response = await _supabase
          .from('vw_lot_summary')
          .select()
          .eq('parent_object_uuid', parentUuid)
          .maybeSingle();

      if (response == null) {
        break;
      }

      latestLot = response;
      parentUuid = response['lot_uuid'] as String;
    }

    if (latestLot == null) {
      return null;
    }

    return LotSummary(
      parentObjectUuid: latestLot['parent_object_uuid'],
      lotUuid: latestLot['lot_uuid'],
      latestEventDate: latestLot['latest_event_date'],
      latestEventDisplayValue: latestLot['latest_event_display_value'],
      latestEventTypeUuid: latestLot['latest_event_type_uuid'],
      latestEventUuid: latestLot['latest_event_uuid'],
      eventIconCode: latestLot['latest_event_icon_code'],
      lotQuantity: latestLot['total_seeds'],
      remainingQuantity: latestLot['remaining_seeds'],
    );
  }

  // Get lot history from lotUuid list
  Future<List<LotHistory>> getOpenLotHistoryLotUuid(List<String> lotUuids) async {
    final response = await _supabase.from('vw_lot_history').select().inFilter('lot_uuid', lotUuids);

    return response.map<LotHistory>((lotHistory) {
      return LotHistory(
        parentObjectUuid: lotHistory['parent_object_uuid'],
        lotUuid: lotHistory['lot_uuid'],
        eventDate: lotHistory['event_date'],
        eventDisplayValue: lotHistory['event_display_value'],
        eventTypeUuid: lotHistory['event_type_uuid'],
        eventUuid: lotHistory['event_uuid'],
        eventIconCode: lotHistory['event_icon_code'],
        lotQuantity: lotHistory['lot_quantity'],
        remainingQuantity: lotHistory['lot_remaining_quantity'],
        displaySequence: lotHistory['event_display_sequence'],
      );
    }).toList();
  }

  // Get lot history from lot UUID
  Future<LotHistory> getLotSummaryFromUuid(String lotUuid) async {
    final response = await _supabase.from('vw_lot_history').select().eq('lot_uuid', lotUuid).single();

    return LotHistory(
      parentObjectUuid: response['parent_object_uuid'],
      lotUuid: response['lot_uuid'],
      eventDate: response['event_date'],
      eventDisplayValue: response['event_display_value'],
      eventTypeUuid: response['event_type_uuid'],
      eventUuid: response['event_uuid'],
      eventIconCode: response['event_icon_code'],
      lotQuantity: response['lot_quantity'],
      remainingQuantity: response['lot_remaining_quantity'],
    );
  }

  // Get all open lots from seed packet - straight line only
  Future<List<LotSummary>> getAllOpenLotsFromPacket(String seedPacketUuid) async {
    final response = await _supabase
        .from('vw_lot_summary')
        .select()
        .eq('seed_packet_uuid', seedPacketUuid)
        .gt('remaining_seeds', 0);

    return response.map<LotSummary>((lot) {
      return LotSummary(
        parentObjectUuid: lot['parent_object_uuid'],
        lotUuid: lot['lot_uuid'],
        latestEventDate: lot['latest_event_date'],
        latestEventDisplayValue: lot['latest_event_display_value'],
        latestEventTypeUuid: lot['latest_event_type_uuid'],
        latestEventUuid: lot['latest_event_uuid'],
        eventIconCode: lot['latest_event_icon_code'],
        lotQuantity: lot['total_seeds'],
        remainingQuantity: lot['remaining_seeds'],
      );
    }).toList();
  }
}
