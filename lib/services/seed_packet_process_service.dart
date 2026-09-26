import 'package:seedsage/seed_sage.dart';

class SeedPacketProcessService {
  final ObjectCrudService _objectService = ObjectCrudService();
  final SeedPacketService _seedPacketService = SeedPacketService();
  final LotCrudService _lotService = LotCrudService();
  final EvtObjCrudService createEvtObj = EvtObjCrudService();
  final TotCrudService _totalService = TotCrudService();

  final String _seedPacketObjectTypeUuid = '4ef66b41-51e1-4ac1-80c9-2031246258c9';
  final String _notSownEventUuid = 'dc7d6ad9-2862-434f-81f6-d15cf047d3b6';
  final String _lotObjectTypeUuid = '49916874-31e4-4aa2-884f-a269ee7a5fa2';
  final String _totDefUuid = '18dc4aba-e362-4462-a8aa-3dd3471d6b99';

  Future<void> createSeedPacketWithInitialLot({
    required String seedTypeUuid,
    required String source,
    required DateTime purchaseDate,
    int? initialSeedQuantity,
  }) async {
    // Create seed packet object
    final seedPacketObjectUuid = await _objectService.createObjectfromType(_seedPacketObjectTypeUuid);

    // Create seed packet
    final seedPacket = SeedPacket(
      seedPacketObjectUuid: seedPacketObjectUuid,
      seedTypeUuid: seedTypeUuid,
      source: source,
      purchaseDate: purchaseDate,
      initialSeedQuantity: initialSeedQuantity,
    );

    await _seedPacketService.createSeedPacket(seedPacket);

    // Create initial lot object
    final lotObjectUuid = await _objectService.createObjectfromType(_lotObjectTypeUuid);

    // Create initial lot with seed packet as parent
    await _lotService.createLotFromParent(seedPacketObjectUuid, lotObjectUuid);

    // Create initial event on seed packet
    await createEvtObj.createEvtObj(seedPacketObjectUuid, _notSownEventUuid);

    // Create initial even on lot
    await createEvtObj.createEvtObj(lotObjectUuid, _notSownEventUuid);

    //Create initial quantity on lot
    if (seedPacket.initialSeedQuantity != null) {
      await _totalService.createTotObj(lotObjectUuid, _totDefUuid, seedPacket.initialSeedQuantity!);
    }
  }
}
