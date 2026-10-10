import 'package:seedsage/models/seed_packet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeedPacketService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // DELETE RULE:
  // 1. obj_object deletion cascades to records dependent on that object.
  // 2. Database cascade never deletes another obj_object.
  // 3. Child obj_object records are explicitly deleted by the process service.
  // 4. Deletion never cascades upward to a parent.

  // Create a seed packet using submitted attributes
  Future<void> createSeedPacket(SeedPacket seedPacket) async {
    await _supabase.from('obj_seed_packet').insert({
      'seed_packet_object_uuid': seedPacket.seedPacketObjectUuid,
      'source': seedPacket.source,
      'purchase_date': seedPacket.purchaseDate?.toIso8601String().split('T').first,
      'initial_seed_quantity': seedPacket.initialSeedQuantity,
      'seed_type_uuid': seedPacket.seedTypeUuid,
    });
  }

  // Create a seed packet using submitted attributes
  Future<SeedPacket> getSeedPacketFromUuid(String seedPacketUuid) async {
    final response = await _supabase
        .from('obj_seed_packet')
        .select()
        .eq('seed_packet_object_uuid', seedPacketUuid)
        .maybeSingle();

    final seedPacket = SeedPacket(
      seedPacketObjectUuid: seedPacketUuid,
      seedTypeUuid: response?['seed_type_uuid'] ?? '',
      source: response?['source'] ?? '',
      purchaseDate: response?['purchase_date'] != null ? DateTime.parse(response!['purchase_date']) : null,
      initialSeedQuantity: response?['initial_seed_quantity'] ?? '',
    );

    return seedPacket;
  }

  // Get packets from seed type
  Future<List<SeedPacket>> getSeedPacketsFromSeedType(String seedTypeUuid) async {
    final response = await _supabase
        .from('obj_seed_packet')
        .select()
        .eq('seed_type_uuid', seedTypeUuid)
        .order('purchase_date');

    return response.map<SeedPacket>((row) {
      return SeedPacket(
        seedPacketObjectUuid: row['seed_packet_object_uuid'],
        seedTypeUuid: row['seed_type_uuid'],
        source: row['source'] ?? '',
        purchaseDate: row['purchase_date'] != null ? DateTime.parse(row['purchase_date']) : null,
        initialSeedQuantity: row['initial_seed_quantity'],
      );
    }).toList();
  }

  // Get packet from seed
  Future<List<String>> getSeedPacketObjectUuidsBySeedType(String seedTypeUuid) async {
    final response = await _supabase
        .from('obj_seed_packet')
        .select('seed_packet_object_uuid')
        .eq('seed_type_uuid', seedTypeUuid);

    return response.map<String>((row) => row['seed_packet_object_uuid'] as String).toList();
  }

  // Update a seed packet using submitted attributes based on the seed packet UUID
  Future<void> updateSeedPacket(SeedPacket seedPacket) async {
    await _supabase
        .from('obj_seed_packet')
        .update({
          'source': seedPacket.source,
          'purchase_date': seedPacket.purchaseDate?.toIso8601String().split('T').first,
          'initial_seed_quantity': seedPacket.initialSeedQuantity,
        })
        .eq('seed_packet_object_uuid', seedPacket.seedPacketObjectUuid);
  }

  // Create a seed packet using submitted attributes
  Future<List<SeedPacketSummary>> getSeedPacketSummaryFromTypeUuid(String seedTypeUuid) async {
    final response = await _supabase.from('vw_seed_packet_summary').select().eq('seed_type_uuid', seedTypeUuid);

    return response.map((row) {
      return SeedPacketSummary(
        seedPacketObjectUuid: row['seed_packet_uuid'],
        seedTypeUuid: row['seed_type_uuid'],
        source: row['source'],
        purchaseDate: row['purchase_date'] != null ? DateTime.parse(row['purchase_date']) : null,
        initialSeedQuantity: row['initial_seed_quantity'],
        remainingQuantity: row['remaining_quantity'],
        latestEventUuid: row['latest_event_uuid'],
        latestEventTypeUuid: row['latest_event_type_uuid'],
        latestEventDisplayValue: row['latest_event_display_value'],
        latestEventIconCode: row['latest_event_icon_code'] ?? '',
        latestEventDate: DateTime.parse(row['latest_event_date']),
        latestEventDispaySequence: row['latest_event_display_sequence'],
      );
    }).toList();
  }
}
