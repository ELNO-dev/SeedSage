import 'package:seedsage/models/seed_packet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      'purchase_date': seedPacket.purchaseDate,
      'initial_seed_quantity': seedPacket.initialSeedQuantity,
      'seed_type_uuid': seedPacket.seedTypeUuid,
    });
  }
}
