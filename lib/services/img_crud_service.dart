import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/images.dart';
import 'dart:typed_data';

class ImgCrudService {
  final _supabase = Supabase.instance.client;

  Future<List<Img>> getImagesByType(String imageTypeUuid) async {
    final response = await _supabase
        .from('obj_image')
        .select('image_object_uuid, storage_path, search_terms')
        .eq('image_type_uuid', imageTypeUuid);

    final imgs = response.map((row) {
      return Img(
        imageObjectUuid: row['image_object_uuid'],
        storagePath: row['storage_path'],
        searchTerms: row['search_terms'],
      );
    }).toList();

    return imgs;
  }

  Future<Uint8List> getImage(String storagePath) async {
    final stopwatch = Stopwatch()..start();

    debugPrint('START: $storagePath');

    try {
      final imageBytes = await _supabase.storage.from('Images').download(storagePath);

      stopwatch.stop();

      debugPrint(
        'DONE: $storagePath | '
        '${imageBytes.lengthInBytes} bytes | '
        '${stopwatch.elapsedMilliseconds} ms',
      );

      return imageBytes;
    } catch (e) {
      stopwatch.stop();
      debugPrint('IMAGE ERROR: $e');
      rethrow;
    }
  }

  Future<Img?> getImagesByObjectandType(String objectUuid, String imageTypeUuid) async {
    final response = await _supabase
        .from('img_object_link')
        .select('''
      *,
      obj_image!inner(*)
    ''')
        .eq('object_uuid', objectUuid)
        .eq('obj_image.image_type_uuid', imageTypeUuid)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return Img(
      imageObjectUuid: response['obj_image']['image_object_uuid'],
      storagePath: response['obj_image']['storage_path'],
      searchTerms: response['obj_image']['search_terms'],
    );
  }

  Future<void> updateImageLink(String objectUuid, String imageObjectUuid) async {
    final response = await _supabase
        .from('img_object_link')
        .update({'image_object_uuid': imageObjectUuid})
        .eq('object_uuid', objectUuid)
        .select();

    debugPrint('IMAGE UPDATE RESPONSE: $response');
  }

  Future<void> createImageLink(String objectUuid, String imageObjectUuid) async {
    await _supabase.from('img_object_link').insert({'image_object_uuid': imageObjectUuid, 'object_uuid': objectUuid});
  }

  Future<void> deleteImageLink(String objectUuid) async {
    await _supabase.from('img_object_link').delete().eq('object_uuid', objectUuid);
  }
}
