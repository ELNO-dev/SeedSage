import 'package:seedsage/models/seed_packet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SeedPacketService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Delete a seed packet based on a submitted UUID
  Future<void> deleteSeedPacket(String seedPacketUuid) async {
    // ELLEN: deletion order must handle child lots before deleting parent obj_object.
    await _supabase.from('obj_seed_packet').delete().eq('seed_packet_object_uuid', seedPacketUuid);
  }

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
    debugPrint('source in CRUD: ${seedPacket.source}');
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
}
