import 'package:seedsage/seed_sage.dart';
import 'package:flutter/foundation.dart';

// DELETE RULE:
// 1. obj_object deletion cascades to records dependent on that object.
// 2. Database cascade never deletes another obj_object.
// 3. Child obj_object records are explicitly deleted by the process service.
// 4. Deletion never cascades upward to a parent.

class LotProcessService {
  final LotCrudService _lotCrudService = LotCrudService();
  final ObjectCrudService _objectService = ObjectCrudService();
  final EvtObjCrudService _eventService = EvtObjCrudService();
  final TotCrudService _totalService = TotCrudService();

  // Get lot history from latest lot
  Future<List<LotHistory>> getLotHistory({required String latestLotUuid, required String seedPacketUuid}) async {
    final List<String> lotUuids = [];

    String currentLotUuid = latestLotUuid;

    while (true) {
      final lot = await _lotCrudService.getLotObjectFromUuid(currentLotUuid);

      lotUuids.add(lot.lotUuid);

      if (lot.parentObjectUuid == seedPacketUuid) {
        break;
      }
      currentLotUuid = lot.parentObjectUuid;
    }
    final history = await _lotCrudService.getLotHistoryLotUuidList(lotUuids);
    return history;
  }

  // add an event to a lot
  Future<String> addLotEvent({
    required String parentLotUuid,
    required int seedQuantity,
    required String eventMdUuid,
    required DateTime eventDate,
    required String seedPacketUuid,
    required String seedTypeUuid,
  }) async {
    // Get quantity available on parent lot
    final parentLotQuantity = (await _lotCrudService.getLotFromHistory(parentLotUuid)).remainingQuantity;

    // Validate quantity
    if (seedQuantity > parentLotQuantity) {
      throw Exception('Seed quantity cannot exceed parent lot quantity');
    }
    // Create lot object
    final lotObjectUuid = await _objectService.createObjectfromType(SeedDefinitions.objObjectTypeLotUuid);

    // Create lot from parent UUID
    await _lotCrudService.createLotFromParent(parentLotUuid, lotObjectUuid, seedPacketUuid);

    // Create event on lot
    await _eventService.createEvtObjwithDate(lotObjectUuid, eventMdUuid, eventDate);

    //Create initial quantity on lot

    await _totalService.createTotObj(lotObjectUuid, SeedDefinitions.lotQuantityDef, seedQuantity);

    //Create remaining quantity on lot
    await _totalService.createTotObj(lotObjectUuid, SeedDefinitions.lotRemainingQuantityDef, seedQuantity);

    // update parent remaining lot quantity
    final parentRemainingLotQuantity = parentLotQuantity - seedQuantity;

    await _totalService.updateTotObj(
      parentLotUuid,
      SeedDefinitions.lotRemainingQuantityDef,
      parentRemainingLotQuantity,
    );

    // Create  event on seed packet
    await _eventService.createEvtObjwithDate(seedPacketUuid, eventMdUuid, eventDate);

    // Create  event on seed type
    await _eventService.createEvtObjwithDate(seedTypeUuid, eventMdUuid, eventDate);

    // return the new lot object UUID
    return lotObjectUuid;
  }

  // Get lot history from latest lot
  Future<List<LotHistory>> getAllOpenLots({required String seedPacketUuid}) async {
    final List<String> lotUuids = [];

    String currentLotUuid = seedPacketUuid;

    while (true) {
      final lot = await _lotCrudService.getLotSummaryFromUuid(currentLotUuid);

      if (lot.remainingQuantity > 0) {
        lotUuids.add(lot.lotUuid);
      }

      if (lot.parentObjectUuid == seedPacketUuid) {
        break;
      }
      currentLotUuid = lot.parentObjectUuid;
    }
    final history = await _lotCrudService.getOpenLotHistoryLotUuid(lotUuids);
    return history;
  }
}
