class SeedDefinitions {
  // ===========================================================================
  // MASTER DATA
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Object Type
  // OBJ_OBJECT_TYPE
  // ---------------------------------------------------------------------------

  static const String objObjectTypeMdTypeUuid = '394aa76b-8961-4007-8fc0-8181dba96d60';

  static const String objObjectTypeSeedTypeUuid = 'b7b32ba7-9d8e-4677-a3f3-dac08259db82';

  static const String objObjectTypeSeedPacketUuid = '4ef66b41-51e1-4ac1-80c9-2031246258c9';

  static const String objObjectTypeImageUuid = '76e16274-c1ed-4a13-817f-4f552541ee97';

  static const String objObjectTypeUserUuid = '7e39b0ab-ee08-4a64-aa99-b9c19cbce353';

  static const String objObjectTypeLotUuid = '49916874-31e4-4aa2-884f-a269ee7a5fa2';

  // ---------------------------------------------------------------------------
  // Object Status
  // OBJ_STATUS
  // ---------------------------------------------------------------------------
  static const String objectStatusMdType = 'OBJ_STATUS';

  static const String objectEventsMdType = 'EVT_OBJ_EVENT_TYPE';

  static const String objStatusMdTypeUuid = '85f4a126-bb3e-46b0-8a3c-5f9b25d7ef87';

  static const String objStatusNotSownUuid = '708e51c3-0b1b-45e3-815b-1df90d6f95bf';

  static const String objStatusSownUuid = 'c00b2b3f-9eb3-4305-9a4f-0b003c613e47';

  static const String objStatusSproutedUuid = '01253f27-67d0-4810-8fca-c3fd08cd0293';

  static const String objStatusPlantedUuid = '6acf2f9e-6011-4f54-be8b-9f113960499b';

  static const String objStatusMatureUuid = '492d241b-bc87-4759-b7be-38d815538fb2';

  // ---------------------------------------------------------------------------
  // Event Type
  // EVT_OBJ_EVENT_TYPE
  // ---------------------------------------------------------------------------

  static const String evtObjEventTypeMdTypeUuid = 'b2c349e5-e8d3-440d-81a0-02f3508758d4';

  static const String evtObjEventTypeNotSownUuid = 'dc7d6ad9-2862-434f-81f6-d15cf047d3b6';

  static const String evtObjEventTypeSowingUuid = '0a258245-6d3a-4504-b626-1356994e9b2d';

  static const String evtObjEventTypeGerminationUuid = '1c5b9033-35f0-491d-b88e-20a65e54d6a0';

  static const String evtObjEventTypeTransplantUuid = 'ed3de6b4-275c-4ea7-b188-eead1038dc79';

  static const String evtObjEventTypeFruitingFloweringUuid = '99e88d24-39e8-476d-8c9f-492a9cff9c17';

  static const String evtObjEventTypeMarkAsDoneUuid = 'c8421abf-020d-4b1c-ae6f-f5bcd8e3dcbc';

  static const String evtObjEventTypeNoGerminationUuid = '53312af6-f60d-48ff-83b7-a9424224fd38';

  static const String evtObjEventTypeLostUuid = '682acc2d-ff39-4f33-9647-b5a57e8986c0';

  static const String evtObjEventTypeDiscardedUuid = '3aa134f7-fccf-4d98-a0b5-00e59fb4542e';

  static const String evtObjEventTypeJournalNoteUuid = '1bc6f4b9-3b39-4a87-8857-547d76bde0bd';

  // ---------------------------------------------------------------------------
  // Sowing Location
  // EVT_OBJ_ATT_SOWING_LOCATION
  // ---------------------------------------------------------------------------

  static const String evtObjAttSowingLocationMdTypeUuid = 'ea59295d-231c-4a82-a5a1-2837532d7e60';

  static const String evtObjAttSowingLocationIndoorsUuid = '4d521e0b-17aa-4e2f-a9f1-3e2924df8bbe';

  static const String evtObjAttSowingLocationGreenhouseUuid = 'c7560651-b2b6-4b15-9315-d11a5bfee094';

  static const String evtObjAttSowingLocationDirectSowUuid = '02ca6702-574a-484e-ae30-60db1ab03d15';

  static const String evtObjAttSowingLocationOutdoorsUuid = 'f4763fd2-ffae-4928-b80e-a3cc73ae06f1';

  static const String evtObjAttSowingLocationWinterSowingUuid = '6761f87b-a5e4-478b-8a3c-5de932ddae76';

  // ---------------------------------------------------------------------------
  // Image Type
  // OBJ_OBJECT_IMAGE_TYPE
  // ---------------------------------------------------------------------------

  static const String objObjectImageTypeMdTypeUuid = 'c840948c-e3ed-4dbd-93a4-064bfeb84a91';

  static const String objObjectImageSeedTypeDisplayUuid = 'f51c8a56-bdf6-46c5-b53a-0c53ae82310c';

  // ---------------------------------------------------------------------------
  // Image Parent Type
  // OBJ_IMAGE_PARENT_TYPE
  // ---------------------------------------------------------------------------

  static const String objImageParentTypeMdTypeUuid = '46c4a915-3ce5-4ab2-bb7e-cc60b5001f75';

  // ===========================================================================
  // TOTAL DEFINITIONS
  // ===========================================================================

  static const String initialQuantityDef = '8adb0c5e-eb72-4df6-9b87-57321fff49fd';

  static const String remainingQuantityDef = 'bb4775a3-472d-4b00-8308-de25cebfbd4c';

  // ---------------------------------------------------------------------------
  // Seed Packet Totals
  // OBJ_OBJECT_TYPE_SEED_PACKET
  // ---------------------------------------------------------------------------

  /// Germination rate - DECIMAL
  static const String objSeedPacketGerminationRateTotDefUuid = '9fd98af6-a70b-472f-a711-4951943c0f31';

  /// Transplant rate - DECIMAL
  static const String objSeedPacketTransplantRateTotDefUuid = '88b4c9f1-272f-473b-b545-a503f3186650';

  /// Total loss - INTEGER
  static const String objSeedPacketTotalLossTotDefUuid = '69511437-a2ed-4516-afb7-3f35f9105fdc';

  // ---------------------------------------------------------------------------
  // User Totals
  // OBJ_OBJECT_TYPE_USER
  // ---------------------------------------------------------------------------

  /// Not sown - INTEGER
  static const String objUserTotalNotSownTotDefUuid = '18dc4aba-e362-4462-a8aa-3dd3471d6b99';

  /// Sown - INTEGER
  static const String objUserTotalSownTotDefUuid = '6535da38-06f9-461b-bc30-2353cf4cdb24';

  /// Sprouted - INTEGER
  static const String objUserTotalSproutedTotDefUuid = 'd8700987-c25a-4fcf-939e-d51f877eff4f';

  /// Planted - INTEGER
  static const String objUserTotalPlantedTotDefUuid = 'aa97286d-d026-4f28-808f-1d580ce69b6f';

  /// Mature - INTEGER
  static const String objUserTotalMatureTotDefUuid = 'b33a5d41-1898-44fc-8a80-9bac2f959bc5';

  // ---------------------------------------------------------------------------
  // Germination Light Required
  // OBJ_SEED_TYPE_GERMINATION_LIGHT
  // ---------------------------------------------------------------------------

  static const String objSeedTypeGerminationLightMdTypeUuid = 'b0b65d52-c311-483f-82b8-3cbe28c1fffe';

  static const String objSeedTypeGerminationLightDarknessUuid = '7af5ed69-f2b4-4d0b-9032-6d1cc6b063fd';

  static const String objSeedTypeGerminationLightLightUuid = 'e024cafd-f953-489e-b1d2-c23e01514e62';

  // ---------------------------------------------------------------------------
  // Life Cycle
  // OBJ_SEED_TYPE_LIFE_CYCLE
  // ---------------------------------------------------------------------------

  static const String objSeedTypeLifeCycleMdTypeUuid = '29287fb3-1af0-420a-8837-e62dded344fe';

  static const String objSeedTypeLifeCycleAnnualUuid = 'b577d049-a1b0-48e7-a3cc-809cdac0bb38';

  static const String objSeedTypeLifeCycleBiennialUuid = 'a1d43293-af97-465e-bbb8-f386d62a1f32';

  static const String objSeedTypeLifeCyclePerennialUuid = '283c9f0c-4836-4918-898b-67094d5eb90a';

  // ---------------------------------------------------------------------------
  // Plant Light Requirement
  // OBJ_SEED_TYPE_PLANT_LIGHT_REQUIREMENT
  // ---------------------------------------------------------------------------

  static const String objSeedTypePlantLightRequirementMdTypeUuid = '28279c4b-a5c3-4a60-94cc-9b1776717c5d';

  static const String objSeedTypePlantLightRequirementFullSunUuid = '328f8195-5bdd-43d8-9b3a-ec258e5e4b58';

  static const String objSeedTypePlantLightRequirementPartSunUuid = '28c45823-ab3b-4d21-88e8-092a0ca46448';

  static const String objSeedTypePlantLightRequirementFullShadeUuid = 'af305ff6-5ee8-4777-9827-8747e86f8619';
}
