import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/seed_sage.dart';

class SeedTypeCard extends StatefulWidget {
  final String commonName;
  final String? variant;
  final bool allowImageChange;
  final String? storagePath;
  final String? botanicalName;
  final ValueChanged<Img>? onImageChanged;
  final String? currentObjectUuid;

  const SeedTypeCard({
    super.key,
    required this.commonName,
    required this.allowImageChange,
    this.variant,
    this.storagePath,
    this.botanicalName,
    this.onImageChanged,
    this.currentObjectUuid,
  });

  @override
  State<SeedTypeCard> createState() => _SeedTypeCardState();
}

class _SeedTypeCardState extends State<SeedTypeCard> {
  final ImgCrudService _imgCrudService = ImgCrudService();
  final EvtObjCrudService _eventService = EvtObjCrudService();
  String? _storagePath;
  String? _eventName;
  String? _eventIcon;

  @override
  void initState() {
    super.initState();
    _storagePath = widget.storagePath;
    _latestStatus();
  }

  @override
  void didUpdateWidget(covariant SeedTypeCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.storagePath != widget.storagePath) {
      _storagePath = widget.storagePath;
    }
  }

  // helper to get latest event
  Future<void> _latestStatus() async {
    if (widget.currentObjectUuid == null) {
      return;
    }

    final highestEvent = await _eventService.getHighestEventByDisplaySequence(
      widget.currentObjectUuid!,
      SeedDefinitions.evtObjEventTypeMdTypeUuid,
    );

    if (!mounted) return;
    setState(() {
      _eventName = highestEvent.eventDisplayValue;
      _eventIcon = highestEvent.iconCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: double.infinity,
        alignment: Alignment.topCenter,
        child: AspectRatio(
          aspectRatio: 1.254,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(0.8),
                child: Opacity(
                  opacity: 0.4,
                  child: Image.asset('assets/images/frills/border_v1.png', fit: BoxFit.contain),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 30, 5, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            toTitleCase(widget.commonName),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 12),
                          Text(toTitleCase(widget.variant ?? ''), style: const TextStyle(fontSize: 18)),
                          SizedBox(height: 12),
                          if (_eventName != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(SeedIconService.getIcon(_eventIcon), size: 16, color: const Color(0xFFEC799B)),
                                const SizedBox(width: 6),
                                Text(
                                  toTitleCase(_eventName!),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFFEC799B),
                                  ),
                                ),
                              ],
                            ),
                          Spacer(),
                          Text(
                            toTitleCase(widget.botanicalName ?? ''),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 25, 5),
                      child: Center(
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
                          child: _storagePath == null && widget.allowImageChange
                              ? const Center(
                                  child: Text(
                                    'Click here to select an image...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFA7A19F),
                                    ),
                                  ),
                                )
                              : _storagePath == null && !widget.allowImageChange
                              ? const Center(
                                  child: Text(
                                    'No image selected',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFA7A19F),
                                    ),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
