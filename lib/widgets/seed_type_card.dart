import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/models/images.dart';

import '../pages/seed_type_image_select.dart';
import '../services/img_crud_service.dart';

class SeedTypeCard extends StatefulWidget {
  final String commonName;
  final String? variant;
  final bool allowImageChange;
  final String? storagePath;
  final String? botanicalName;
  final ValueChanged<Img>? onImageChanged;

  const SeedTypeCard({
    super.key,
    required this.commonName,
    required this.allowImageChange,
    this.variant,
    this.storagePath,
    this.botanicalName,
    this.onImageChanged,
  });

  @override
  State<SeedTypeCard> createState() => _SeedTypeCardState();
}

class _SeedTypeCardState extends State<SeedTypeCard> {
  final ImgCrudService _imgCrudService = ImgCrudService();
  String? _storagePath;

  @override
  void initState() {
    super.initState();
    _storagePath = widget.storagePath;
  }

  @override
  void didUpdateWidget(covariant SeedTypeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.storagePath != widget.storagePath) {
      _storagePath = widget.storagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/border_v1.png', fit: BoxFit.contain)),
            Positioned(
              top: 40,
              left: 170,
              child: InkWell(
                onTap: widget.allowImageChange
                    ? () async {
                        final selectedImage = await Navigator.of(
                          context,
                        ).push<Img>(MaterialPageRoute(builder: (context) => const SearchSeedImage()));

                        if (selectedImage == null) return;

                        setState(() {
                          _storagePath = selectedImage.storagePath;
                        });

                        widget.onImageChanged?.call(selectedImage);
                      }
                    : null,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: _storagePath == null && widget.allowImageChange
                      ? const Center(
                          child: Text(
                            'Click here to select an image...',
                            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFFA7A19F)),
                          ),
                        )
                      : _storagePath == null && !widget.allowImageChange
                      ? const Center(
                          child: Text(
                            'No image selected',
                            style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFFA7A19F)),
                          ),
                        )
                      : FutureBuilder<Uint8List>(
                          future: _imgCrudService.getImage(_storagePath!),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Icon(Icons.error);
                            }

                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            return Image.memory(snapshot.data!, fit: BoxFit.contain);
                          },
                        ),
                ),
              ),
            ),
            Positioned(
              top: 32,
              left: 32,
              child: Text(
                toTitleCase(widget.commonName),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            ),
            Positioned(
              top: 62,
              left: 32,
              child: Text(toTitleCase(widget.variant ?? ''), style: const TextStyle(fontSize: 20)),
            ),
            Positioned(
              top: 104,
              left: 32,
              child: Text(
                toTitleCase(widget.botanicalName ?? ''),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
