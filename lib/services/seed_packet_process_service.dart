import 'package:seedsage/seed_sage.dart';
import 'package:flutter/material.dart';

// DELETE RULE:
// 1. obj_object deletion cascades to records dependent on that object.
// 2. Database cascade never deletes another obj_object.
// 3. Child obj_object records are explicitly deleted by the process service.
// 4. Deletion never cascades upward to a parent.

class SeedPacketProcessService {
  final ObjectCrudService _objectService = ObjectCrudService();
  final SeedPacketService _seedPacketService = SeedPacketService();
  final LotCrudService _lotService = LotCrudService();
  final EvtObjCrudService createEvtObj = EvtObjCrudService();
  final TotCrudService _totalService = TotCrudService();

  Future<void> createSeedPacketWithInitialLot({
    required String seedTypeUuid,
    required String source,
    required DateTime purchaseDate,
    int? initialSeedQuantity,
  }) async {
    // Create seed packet object
    final seedPacketObjectUuid = await _objectService.createObjectfromType(SeedDefinitions.objObjectTypeSeedPacketUuid);

    // Create seed packet
    final seedPacket = SeedPacket(
      seedPacketObjectUuid: seedPacketObjectUuid,
      seedTypeUuid: seedTypeUuid,
      source: source,
      purchaseDate: purchaseDate,
      initialSeedQuantity: initialSeedQuantity,
    );

    await _seedPacketService.createSeedPacket(seedPacket);

    // Create initial quantity on seed packet
    if (seedPacket.initialSeedQuantity != null) {
      await _totalService.createTotObj(
        seedPacketObjectUuid,
        SeedDefinitions.initialQuantityDef,
        seedPacket.initialSeedQuantity!,
      );
    }

    // Create remaining quantity on seed packet
    if (seedPacket.initialSeedQuantity != null) {
      await _totalService.createTotObj(
        seedPacketObjectUuid,
        SeedDefinitions.remainingQuantityDef,
        seedPacket.initialSeedQuantity!,
      );
    }

    // Create initial lot object
    final lotObjectUuid = await _objectService.createObjectfromType(SeedDefinitions.objObjectTypeLotUuid);

    // Create initial lot with seed packet as parent
    await _lotService.createLotFromParent(seedPacketObjectUuid, lotObjectUuid, seedPacketObjectUuid);

    // Create initial event on seed packet
    await createEvtObj.createEvtObj(seedPacketObjectUuid, SeedDefinitions.evtObjEventTypeNotSownUuid);

    // Create initial even on lot
    await createEvtObj.createEvtObj(lotObjectUuid, SeedDefinitions.evtObjEventTypeNotSownUuid);

    //Create initial quantity on lot
    if (seedPacket.initialSeedQuantity != null) {
      await _totalService.createTotObj(
        lotObjectUuid,
        SeedDefinitions.initialQuantityDef,
        seedPacket.initialSeedQuantity!,
      );
    }

    //Create remaining quantity on lot
    if (seedPacket.initialSeedQuantity != null) {
      await _totalService.createTotObj(
        lotObjectUuid,
        SeedDefinitions.remainingQuantityDef,
        seedPacket.initialSeedQuantity!,
      );
    }
  }

  Future<void> deleteSeedPacket(String objectUuid) async {
    // Delete seed packet
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
    } catch (error) {
      debugPrint('Error on seed type object delete: $error');
    }
  }

  Future<void> updateSeedPacket(SeedPacket seedPacket) async {
    final packetUuid = seedPacket.seedPacketObjectUuid;
    final newInitialQuantity = seedPacket.initialSeedQuantity;

    if (newInitialQuantity != null) {
      // Get current totals before updating anything
      final oldInitialQuantity = await _totalService.getTotObj(packetUuid, SeedDefinitions.initialQuantityDef, 0);

      final oldRemainingQuantity = await _totalService.getTotObj(packetUuid, SeedDefinitions.remainingQuantityDef, 0);

      // Calculate the adjustment
      final difference = newInitialQuantity - oldInitialQuantity;
      final newRemainingQuantity = oldRemainingQuantity + difference;

      // Prevent negative remaining quantities
      if (newRemainingQuantity < 0) {
        throw Exception('Cannot reduce initial quantity below the number of seeds already allocated.');
      }

      // Update packet attributes
      await _seedPacketService.updateSeedPacket(seedPacket);

      // Update initial quantity on packet
      await _totalService.updateTotObj(packetUuid, SeedDefinitions.initialQuantityDef, newInitialQuantity);

      // Update remaining quantity on packet
      await _totalService.updateTotObj(packetUuid, SeedDefinitions.remainingQuantityDef, newRemainingQuantity);
    } else {
      await _seedPacketService.updateSeedPacket(seedPacket);
    }
  }
}
