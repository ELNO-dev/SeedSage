import 'package:flutter/material.dart';

import 'package:foundation/foundation.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:seedsage/seed_sage.dart';

class SeedDetail extends StatefulWidget {
  final String seedTypeUuid;

  const SeedDetail({super.key, required this.seedTypeUuid});

  @override
  State<SeedDetail> createState() => _SeedDetailState();
}

class _SeedDetailState extends State<SeedDetail> {
  final TextEditingController _commonNameController = TextEditingController();

  final TextEditingController _varietyController = TextEditingController();

  final TextEditingController _botanicalNameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _minGermController = TextEditingController();

  final TextEditingController _maxGermController = TextEditingController();

  final TextEditingController _growingInstController = TextEditingController();

  final TextEditingController _minHeightController = TextEditingController();

  final TextEditingController _maxHeightController = TextEditingController();

  final TextEditingController _minSpaceController = TextEditingController();

  final TextEditingController _maxSpaceController = TextEditingController();

  final TextEditingController _minGermDayController = TextEditingController();

  final TextEditingController _maxGermDayController = TextEditingController();

  final TextEditingController _minTransDayController = TextEditingController();

  final TextEditingController _maxTransDayController = TextEditingController();

  final TextEditingController _minFruitDayController = TextEditingController();

  final TextEditingController _maxFruitDayController = TextEditingController();

  final ImgCrudService _imgCrudService = ImgCrudService();

  final SeedTypeService _seedTypeService = SeedTypeService();

  final SeedPacketService _seedPacketService = SeedPacketService();

  dynamic _lifeCycle;

  List<ElnoMdOption> _lifeCycleOptions = [];

  List<SeedPacket> _seedPackets = [];

  final _formKey = GlobalKey<FormState>();

  final ElnoMdCrudService _mdGetService = ElnoMdCrudService();
  @override
  void initState() {
    super.initState();

    _loadPageData();
  }

  bool _isSaving = false;

  String? _lifeCycleDisplay;

  bool _stratificationRequired = false;

  bool _pinchingRequired = false;

  String? _storagePath;

  Img? _newSelectedImage;

  Img? _existingImage;

  bool _hasChanged = false;

  // Helper to make the sequence run in series not parallel

  Future<void> _loadPageData() async {
    await _loadInitialSeedType();

    await _loadLifeCycleOptions();

    await _loadLifeCycleDisplay();

    await _imageBytes();

    await _loadSeedPackets();
  }

  // Helper to confirm deletion of seed

  Future<bool> _confirmSeedDeletion() async {
    final bool? userConfirmed = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete the seed?'),

          content: const Text(
            'This permanently deletes the seed '
            'and cannot be undone.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },

              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },

              child: const Text('Delete seed', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    return userConfirmed ?? false;
  }

  //Helper to get seed packets

  Future<void> _loadSeedPackets() async {
    final packets = await _seedPacketService.getSeedPacketsFromSeedType(widget.seedTypeUuid);

    if (!mounted) return;

    setState(() {
      _seedPackets = packets;
    });
  }

  // Helper to build seed packet cards

  Widget _buildSeedPacketCard(SeedPacket seedPacket) {
    final hasSource = seedPacket.source != null && seedPacket.source!.trim().isNotEmpty;

    final hasQuantity = seedPacket.initialSeedQuantity != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SeedPacketDetail(
                seedTypeUuid: widget.seedTypeUuid,

                seedPacketUuid: seedPacket.seedPacketObjectUuid,

                commonName: _commonNameController.text,
              ),
            ),
          );

          await _loadSeedPackets();
        },

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),

            borderRadius: BorderRadius.circular(14),

            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),

          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Purchased: ${seedPacket.purchaseDate!.toIso8601String().split('T').first}',

                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        if (hasSource)
                          Text(
                            'from: ${seedPacket.source!}',

                            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF77706E)),
                          ),

                        const Spacer(),

                        if (hasQuantity)
                          Text(
                            'Initial seed quantity: ${seedPacket.initialSeedQuantity}',

                            style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFF77706E)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(LucideIcons.chevronRight, size: 16, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }

  // Helper to set change variable

  void setChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _hasChanged = true;
      });
    }
  }

  // Helper to get the name

  Future<void> _loadInitialSeedType() async {
    final initialSeedType = await _seedTypeService.readSeedTypeDetail(widget.seedTypeUuid);

    if (!mounted) return;

    setState(() {
      _commonNameController.text = initialSeedType.commonName;

      _varietyController.text = initialSeedType.variant ?? '';

      _botanicalNameController.text = initialSeedType.botanicalName ?? '';

      _descriptionController.text = initialSeedType.description ?? '';

      _minGermController.text = initialSeedType.minGerminationTemperatureC?.toString() ?? '';

      _maxGermController.text = initialSeedType.maxGerminationTemperatureC?.toString() ?? '';

      _growingInstController.text = initialSeedType.growingInstructions ?? '';

      _stratificationRequired = initialSeedType.stratificationRequired ?? false;

      _pinchingRequired = initialSeedType.pinchingRequired ?? false;

      _minHeightController.text = initialSeedType.minHeightCm?.toString() ?? '';

      _maxHeightController.text = initialSeedType.maxHeightCm?.toString() ?? '';

      _minSpaceController.text = initialSeedType.minSpacingCm?.toString() ?? '';

      _maxSpaceController.text = initialSeedType.maxSpacingCm?.toString() ?? '';

      _minGermDayController.text = initialSeedType.minGerminationDays?.toString() ?? '';

      _maxGermDayController.text = initialSeedType.maxGerminationDays?.toString() ?? '';

      _minTransDayController.text = initialSeedType.minTransplantDays?.toString() ?? '';

      _maxTransDayController.text = initialSeedType.maxTransplantDays?.toString() ?? '';

      _minFruitDayController.text = initialSeedType.minFlowerFruitDays?.toString() ?? '';

      _maxFruitDayController.text = initialSeedType.maxFlowerFruitDays?.toString() ?? '';

      _lifeCycle = initialSeedType.lifeCycleUuid;
    });
  }

  // Helper for md values

  Future<void> _loadLifeCycleDisplay() async {
    if (_lifeCycle == null) return;

    final getDisplayValue = await _mdGetService.getMdDisplayValue(_lifeCycle);

    if (!mounted) return;

    setState(() {
      _lifeCycleDisplay = getDisplayValue;
    });
  }

  // Helper to get image bytes

  Future<void> _imageBytes() async {
    final selectedImage = await _imgCrudService.getImagesByObjectandType(
      widget.seedTypeUuid,

      'f51c8a56-bdf6-46c5-b53a-0c53ae82310c',
    );

    if (!mounted) return;

    setState(() {
      _existingImage = selectedImage;

      _storagePath = selectedImage?.storagePath;
    });
  }

  // Save Seed Type Helper

  Future<void> _saveSeedType() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    setState(() {
      _isSaving = true;
    });

    final updatedSeedType = SeedType(
      seedTypeObjectUuid: widget.seedTypeUuid,

      commonName: _commonNameController.text.trim(),

      variant: _varietyController.text.trim(),

      botanicalName: _botanicalNameController.text.trim(),

      description: _descriptionController.text.trim(),

      minGerminationTemperatureC: int.tryParse(_minGermController.text),

      maxGerminationTemperatureC: int.tryParse(_maxGermController.text),

      growingInstructions: _growingInstController.text.trim(),

      minHeightCm: int.tryParse(_minHeightController.text),

      maxHeightCm: int.tryParse(_maxHeightController.text),

      minSpacingCm: int.tryParse(_minSpaceController.text),

      maxSpacingCm: int.tryParse(_maxSpaceController.text),

      stratificationRequired: _stratificationRequired,

      pinchingRequired: _pinchingRequired,

      minGerminationDays: int.tryParse(_minGermDayController.text),

      maxGerminationDays: int.tryParse(_maxGermDayController.text),

      minTransplantDays: int.tryParse(_minTransDayController.text),

      maxTransplantDays: int.tryParse(_maxTransDayController.text),

      minFlowerFruitDays: int.tryParse(_minFruitDayController.text),

      maxFlowerFruitDays: int.tryParse(_maxFruitDayController.text),

      lifeCycleUuid: _lifeCycle,

      imageId: null,
    );

    try {
      await _seedTypeService.updateSeedType(updatedSeedType);

      if (_newSelectedImage != null) {
        if (_existingImage == null) {
          await _imgCrudService.createImageLink(widget.seedTypeUuid, _newSelectedImage!.imageObjectUuid);
        } else {
          await _imgCrudService.updateImageLink(widget.seedTypeUuid, _newSelectedImage!.imageObjectUuid);
        }
      }
    } catch (error) {
      // Ellen fucked up

      debugPrint('Ellen fucked up: $error');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  // Helper for lifecycle options

  Future<void> _loadLifeCycleOptions() async {
    final options = await _mdGetService.getMdOptionsByType('OBJ_SEED_TYPE_LIFE_CYCLE');

    if (!mounted) return;

    setState(() {
      _lifeCycleOptions = options;
    });
  }

  // Helper for user close without saving

  Future<void> _promptForSave() async {
    if (_hasChanged == true) {
      await showDialog<bool>(
        context: context,

        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Do you want to exit the screen without saving your changes?'),

            content: const Text('Leaving the screen will mean you lose all changes'),

            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();

                  await _saveSeedType();

                  if (!mounted) return;

                  Navigator.of(context).pop();
                },

                child: const Text('Save and exit'),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);

                  if (!context.mounted) return;

                  Navigator.of(context).pop();
                },

                child: const Text('Discard and exit', style: TextStyle(color: Colors.red)),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  // UI build

  @override
  Widget build(BuildContext pageContext) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) async {
        await _promptForSave();
      },

      child: ElnoPageLayout(
        appConfig: appConfig,

        showBackButton: true,

        promptForSave: _promptForSave,

        mainMenu: MainMenu(appConfig: appConfig),

        pageContent: Form(
          key: _formKey,

          child: Column(
            children: [
              Text('Seed Detail', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),

              const SizedBox(height: 12),

              SeedTypeCard(
                commonName: _commonNameController.text,
                variant: _varietyController.text,
                botanicalName: _botanicalNameController.text,
                storagePath: _storagePath,
                allowImageChange: true,
                onImageChanged: (selectedImage) {
                  setState(() {
                    _newSelectedImage = selectedImage;
                    _storagePath = selectedImage.storagePath;
                    _hasChanged = true;
                  });
                },
              ),

              ExpansionTile(
                title: ElnoSectionHeader(headerString: 'Plant detail'),

                initiallyExpanded: false,

                shape: const Border(),

                collapsedShape: const Border(),

                children: [
                  ElnoTextInput(
                    labelText: 'Common name',

                    hintText: toTitleCase(_commonNameController.text),

                    numLines: 1,

                    requiredField: true,

                    controller: _commonNameController,

                    newController: setChanged,
                  ),

                  const SizedBox(height: 12),

                  ElnoTextInput(
                    labelText: 'Variety',

                    hintText: toTitleCase(_varietyController.text),

                    numLines: 1,

                    requiredField: false,

                    controller: _varietyController,

                    newController: setChanged,
                  ),

                  const SizedBox(height: 12),

                  ElnoTextInput(
                    labelText: 'Botanical name',

                    hintText: toTitleCase(_botanicalNameController.text),

                    numLines: 1,

                    requiredField: false,

                    controller: _botanicalNameController,

                    newController: setChanged,
                  ),

                  const SizedBox(height: 24),

                  Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),

                  const SizedBox(height: 32),
                ],
              ),

              ExpansionTile(
                title: ElnoSectionHeader(headerString: 'Plant details'),

                initiallyExpanded: false,

                shape: const Border(),

                collapsedShape: const Border(),

                children: [
                  const SizedBox(height: 12),

                  ElnoTextInput(
                    labelText: 'Description',

                    hintText: toTitleCase(_descriptionController.text),

                    numLines: 4,

                    requiredField: false,

                    controller: _descriptionController,

                    newController: setChanged,
                  ),

                  // Text(_lifeCycleDisplay ?? 'No life cycle'),
                  const SizedBox(height: 12),

                  ElnoMdInput(
                    labelText: 'Life cycle',

                    options: _lifeCycleOptions,

                    hintText: _lifeCycleDisplay,

                    value: _lifeCycle,

                    onChanged: (newValue) {
                      setChanged(newValue.toString());

                      setState(() {
                        _lifeCycle = newValue;
                      });
                    },

                    requiredField: false,
                  ),

                  const SizedBox(height: 12),

                  ElnoMinMaxInput(
                    labelText: 'Final height',

                    minHintText: 'Minimum',

                    maxHintText: 'Maximum',

                    minController: _minHeightController,

                    maxController: _maxHeightController,

                    newController: setChanged,

                    requiredField: false,
                  ),

                  const SizedBox(height: 12),

                  ElnoMinMaxInput(
                    labelText: 'Spacing',

                    minHintText: 'Minimum',

                    maxHintText: 'Maximum',

                    minController: _minSpaceController,

                    maxController: _maxSpaceController,

                    newController: setChanged,

                    requiredField: false,
                  ),

                  const SizedBox(height: 24),

                  Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),

                  const SizedBox(height: 32),
                ],
              ),

              ExpansionTile(
                title: ElnoSectionHeader(headerString: 'Germination'),

                initiallyExpanded: false,

                shape: const Border(),

                collapsedShape: const Border(),

                children: [
                  const SizedBox(height: 12),

                  ElnoMinMaxInput(
                    labelText: 'Germination temperature',

                    minHintText: 'Minimum °C',

                    maxHintText: 'Maximum °C',

                    minController: _minGermController,

                    maxController: _maxGermController,

                    newController: setChanged,

                    requiredField: false,
                  ),

                  const SizedBox(height: 12),

                  ElnoBoolInput(
                    labelText: 'Stratification required',

                    value: _stratificationRequired,

                    onChanged: (newValue) {
                      setChanged(newValue.toString());

                      setState(() {
                        _stratificationRequired = newValue;
                      });
                    },

                    requiredField: false,
                  ),

                  const SizedBox(height: 12),

                  ElnoBoolInput(
                    labelText: 'Pinching required',

                    value: _pinchingRequired,

                    onChanged: (newValue) {
                      setChanged(newValue.toString());

                      setState(() {
                        _pinchingRequired = newValue;
                      });
                    },

                    requiredField: false,
                  ),

                  const SizedBox(height: 12),

                  ElnoTextInput(
                    labelText: 'Growing instructions',

                    hintText: toTitleCase(_growingInstController.text),

                    numLines: 4,

                    requiredField: false,

                    controller: _growingInstController,

                    newController: setChanged,
                  ),

                  const SizedBox(height: 24),

                  Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),

                  const SizedBox(height: 32),
                ],
              ),

              ExpansionTile(
                title: ElnoSectionHeader(headerString: 'Timing'),

                initiallyExpanded: false,

                shape: const Border(),

                collapsedShape: const Border(),

                children: [
                  const SizedBox(height: 12),

                  ElnoMinMaxInput(
                    labelText: 'Germination days',

                    minHintText: 'Minimum',

                    maxHintText: 'Maximum',

                    minController: _minGermDayController,

                    maxController: _maxGermDayController,

                    newController: setChanged,

                    requiredField: false,
                  ),

                  const SizedBox(height: 12),

                  ElnoMinMaxInput(
                    labelText: 'Transplant days',

                    minHintText: 'Minimum',

                    maxHintText: 'Maximum',

                    minController: _minTransDayController,

                    maxController: _maxTransDayController,

                    newController: setChanged,

                    requiredField: false,
                  ),

                  const SizedBox(height: 12),

                  ElnoMinMaxInput(
                    labelText: 'Flower/Fruit days',

                    minHintText: 'Minimum',

                    maxHintText: 'Maximum',

                    minController: _minFruitDayController,

                    maxController: _maxFruitDayController,

                    newController: setChanged,

                    requiredField: false,
                  ),

                  const SizedBox(height: 24),

                  Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),

                  const SizedBox(height: 32),
                ],
              ),

              ExpansionTile(
                title: ElnoSectionHeader(headerString: 'Seed Packets'),

                initiallyExpanded: false,

                shape: const Border(),

                collapsedShape: const Border(),

                children: [
                  const SizedBox(height: 24),

                  ..._seedPackets.map((seedPacket) => _buildSeedPacketCard(seedPacket)),

                  if (_seedPackets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 10),

                      child: Text(
                        'No seed packets',

                        style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xFFA7A19F)),
                      ),
                    ),

                  const SizedBox(height: 24),

                  Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),

                  const SizedBox(height: 32),
                ],
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),

                  backgroundColor: _hasChanged ? const Color(0xFFF6C3D3) : const Color(0xFFFFFFFF),
                ),

                onPressed: () async {
                  await _saveSeedType();

                  _hasChanged = false;
                },

                child: _isSaving
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Update the seed', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),

        floatingActionButton: ElnoFab(
          fabIcon: LucideIcons.pencil100,

          actions: [
            ElnoFabAction(
              fabActionIcon: LucideIcons.trash,

              label: 'Delete seed type',

              onSelected: () async {
                final bool userConfirmed = await _confirmSeedDeletion();

                if (!userConfirmed) {
                  return;
                }

                try {
                  await _seedTypeService.deleteSeedType(widget.seedTypeUuid);

                  if (!pageContext.mounted) return;

                  Navigator.pop(pageContext);
                } catch (error) {
                  if (!pageContext.mounted) return;

                  ScaffoldMessenger.of(
                    pageContext,
                  ).showSnackBar(AppSnackBar.failed(message: 'Seed could not be deleted, please try again later'));
                }
              },
            ),

            ElnoFabAction(
              fabActionIcon: LucideIcons.mailOpen,

              label: 'Add seed packet',

              onSelected: () async {
                await Navigator.of(pageContext).push(
                  MaterialPageRoute(
                    builder: (context) => AddSeedPacket(
                      seedTypeUuid: widget.seedTypeUuid,

                      commonName: _commonNameController.text,

                      variety: _varietyController.text,

                      botanicalName: _botanicalNameController.text,

                      storagePath: _storagePath,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
