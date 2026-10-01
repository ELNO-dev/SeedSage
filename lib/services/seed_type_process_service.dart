import 'package:seedsage/seed_sage.dart';
import 'package:flutter/material.dart';

// DELETE RULE:
// 1. obj_object deletion cascades to records dependent on that object.
// 2. Database cascade never deletes another obj_object.
// 3. Child obj_object records are explicitly deleted by the process service.
// 4. Deletion never cascades upward to a parent.

class SeedTypeProcessService {
  final ObjectCrudService _objectService = ObjectCrudService();
  final SeedPacketService _seedPacketService = SeedPacketService();
  final LotCrudService _lotService = LotCrudService();
  // delete seed type
  Future<void> deleteSeedType(String objectUuid) async {
    // Delete seed type
    try {
      // Get all packets belonging to the seed type
      final packetObjectUuids = await _seedPacketService.getSeedPacketObjectUuidsBySeedType(objectUuid);

      // Get all lots belonging to all packets
      final lotObjectUuids = await _lotService.getLotObjectUuidsBySeedPackets(packetObjectUuids);

      // Delete all lots
      for (final lotObjectUuid in lotObjectUuids) {
        await _objectService.deleteObject(lotObjectUuid);
      }

      // Delete all packets
      for (final packetObjectUuid in packetObjectUuids) {
        await _objectService.deleteObject(packetObjectUuid);
      }

      // Delete seed type
      await _objectService.deleteObject(objectUuid);
    } catch (error) {
      debugPrint('Error on seed type object delete: $error');
    }
  }
}
