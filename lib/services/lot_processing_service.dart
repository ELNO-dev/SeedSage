import 'package:seedsage/seed_sage.dart';

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
    // Get quantity remaining on parent lot
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

    await _totalService.createTotObj(lotObjectUuid, SeedDefinitions.initialQuantityDef, seedQuantity);

    //Create remaining quantity on lot
    await _totalService.createTotObj(lotObjectUuid, SeedDefinitions.remainingQuantityDef, seedQuantity);

    // update parent remaining lot quantity
    final parentRemainingLotQuantity = parentLotQuantity - seedQuantity;

    await _totalService.updateTotObj(parentLotUuid, SeedDefinitions.remainingQuantityDef, parentRemainingLotQuantity);
    // Get latest event on seed packet
    final packetHighestEvent = await _eventService.getHighestEventByDisplaySequence(
      seedPacketUuid,
      SeedDefinitions.evtObjEventTypeMdTypeUuid,
    );
    final int packetHighestDisplaySeq = packetHighestEvent.eventDisplaySequence!;

    final lotHighestEvent = await _eventService.getHighestEventByDisplaySequence(
      lotObjectUuid,
      SeedDefinitions.evtObjEventTypeMdTypeUuid,
    );
    final int lotEventDisplaySequence = lotHighestEvent.eventDisplaySequence!;
    if (lotEventDisplaySequence > packetHighestDisplaySeq) {
      // Create  event on seed packet
      await _eventService.createEvtObjwithDate(seedPacketUuid, eventMdUuid, eventDate);
    }

    // Create  event on seed type
    final newPacketHighestEvent = await _eventService.getHighestEventByDisplaySequence(
      seedPacketUuid,
      SeedDefinitions.evtObjEventTypeMdTypeUuid,
    );
    final int newPacketHighestDisplaySeq = newPacketHighestEvent.eventDisplaySequence!;

    final seedTypeHighestEvent = await _eventService.getHighestEventByDisplaySequence(
      seedTypeUuid,
      SeedDefinitions.evtObjEventTypeMdTypeUuid,
    );
    final int seedTypeEventDisplaySequence = seedTypeHighestEvent.eventDisplaySequence!;
    if (newPacketHighestDisplaySeq > seedTypeEventDisplaySequence) {
      await _eventService.createEvtObjwithDate(seedTypeUuid, newPacketHighestEvent.eventTypeUuid, eventDate);
    }
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
