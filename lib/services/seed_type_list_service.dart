import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:seedsage/seed_sage.dart';

class SeedTypeListService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<SeedTypeListData>> getSeedTypes(SeedTypeListQuery query) async {
    // STEP 1: Get seed types
    var request = _supabase.from('obj_seed_type').select();

    if (query.commonName != null && query.commonName!.isNotEmpty) {
      request = request.ilike('common_name', '%${query.commonName}%');
    }

    if (query.variant != null && query.variant!.isNotEmpty) {
      request = request.ilike('variant', '%${query.variant}%');
    }

    final response = await request;

    if (response.isEmpty) return [];

    // STEP 2: Get all relevant event histories in ONE request
    final seedUuids = response.map((row) => row['seed_type_object_uuid'] as String).toList();

    final eventResponse = await _supabase
        .from('vw_event_history')
        .select('object_uuid, event_type_uuid, display_sequence')
        .eq('master_data_type_uuid', SeedDefinitions.evtObjEventTypeMdTypeUuid)
        .inFilter('object_uuid', seedUuids)
        .order('display_sequence', ascending: false);

    // STEP 3: Find the highest event for each seed type
    final Map<String, String> latestEvents = {};

    for (final event in eventResponse) {
      final objectUuid = event['object_uuid'] as String;

      // Since events are sorted highest first,
      // keep the first event found for each seed.
      latestEvents.putIfAbsent(objectUuid, () => event['event_type_uuid'] as String);
    }

    // STEP 4: Build our existing seed models
    final List<SeedTypeListData> seeds = [];

    for (final row in response) {
      final seedUuid = row['seed_type_object_uuid'] as String;

      final rowWithEvent = {...row, 'event_uuid': latestEvents[seedUuid]};

      seeds.add(SeedTypeListData.fromMap(rowWithEvent));
    }

    return seeds;
  }
}
