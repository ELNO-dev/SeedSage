import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/seed_type_list_data.dart';

class SeedTypeListService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<SeedTypeListData>> getSeedTypes(SeedTypeListQuery query) async {
    var request = _supabase.from('obj_seed_type').select();
    final response1 = await request;
    debugPrint('SEED TYPES FOUND: ${response1.length}');

    for (final row in response1) {
      debugPrint(
        'SEED: ${row['common_name']} | '
        'UUID: ${row['seed_type_object_uuid']}',
      );
    }
    if (query.commonName != null && query.commonName!.isNotEmpty) {
      request = request.ilike('common_name', '%${query.commonName}%');
    }

    if (query.variant != null && query.variant!.isNotEmpty) {
      request = request.ilike('variant', '%${query.variant}%');
    }

    final response = await request;

    final List<SeedTypeListData> seeds = [];

    final seedUuids = response.map<String>((row) => row['seed_type_object_uuid'] as String).toList();

    final eventResponse = await _supabase
        .from('evt_obj')
        .select('object_uuid, event_type_uuid, event_date')
        .inFilter('object_uuid', seedUuids)
        .order('event_date', ascending: false);

    debugPrint('EVENT ROWS RETURNED: ${eventResponse.length}');
    for (final row in response) {
      final seedUuid = row['seed_type_object_uuid'] as String;

      final matchingEvents = eventResponse.where((event) => event['object_uuid'] == seedUuid);

      final latestEventUuid = matchingEvents.isEmpty ? null : matchingEvents.first['event_type_uuid'] as String?;

      final rowWithEvent = {...row, 'event_uuid': latestEventUuid};

      seeds.add(SeedTypeListData.fromMap(rowWithEvent));
    }
    return seeds;
  }
}

/*
    return response
    .map<SeedTypeListData>(
      (row) => SeedTypeListData.fromMap(row),
    )
    .toList();
  }
}*/
