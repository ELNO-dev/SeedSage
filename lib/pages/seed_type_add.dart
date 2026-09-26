import 'package:flutter/material.dart';

import 'package:foundation/foundation.dart';

import 'package:seedsage/seed_sage.dart';

class AddSeedType extends StatefulWidget {
  const AddSeedType({super.key});

  @override
  State<AddSeedType> createState() => _AddSeedTypeState();
}

class _AddSeedTypeState extends State<AddSeedType> {
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
  final _formKey = GlobalKey<FormState>();
  final SeedTypeService _seedTypeService = SeedTypeService();
  final ObjectCrudService _objectService = ObjectCrudService();
  final EvtObjCrudService _evtObjCrudService = EvtObjCrudService();

  void _clearForm() {
    _commonNameController.clear();
    _varietyController.clear();
    _botanicalNameController.clear();
    _descriptionController.clear();
    _minGermController.clear();
    _maxGermController.clear();
    _growingInstController.clear();
    _minHeightController.clear();
    _maxHeightController.clear();
    _minSpaceController.clear();
    _maxSpaceController.clear();
    _minGermDayController.clear();
    _maxGermDayController.clear();
    _minTransDayController.clear();
    _maxTransDayController.clear();
    _minFruitDayController.clear();
    _maxFruitDayController.clear();

    setState(() {
      _lifeCycle = null;
      _stratificationRequired = false;
      _pinchingRequired = false;
      _selectedImage = null;
    });

    _formKey.currentState?.reset();
  }

  final ElnoMdCrudService _mdService = ElnoMdCrudService();
  bool _stratificationRequired = false;
  bool _pinchingRequired = false;
  String? _lifeCycle;
  List<ElnoMdOption> _lifeCycleOptions = [];
  Img? _selectedImage;
  String? _seedTypeObjectTypeUuid;
  String? _seedTypeObjectStatusUuid;
  bool _isSaving = false;

  Future<void> _loadSeedTypeObjectType() async {
    final options = await _mdService.getMdOptionsByType('OBJ_OBJECT_TYPE');

    final seedTypeOption = options.firstWhere((option) => option.valueCode == 'OBJ_OBJECT_TYPE_SEED_TYPE');

    setState(() {
      _seedTypeObjectTypeUuid = seedTypeOption.uuid;
    });
  }

  Future<void> _loadSeedTypeStatus() async {
    final options = await _mdService.getMdOptionsByType('OBJ_STATUS');

    final seedTypeStatus = options.firstWhere((option) => option.valueCode == 'OBJ_STATUS_NOT_SOWN');

    setState(() {
      _seedTypeObjectStatusUuid = seedTypeStatus.uuid;
    });
  }

  Future<void> _testLifeCycleLoad() async {
    final options = await _mdService.getMdOptionsByType('OBJ_SEED_TYPE_LIFE_CYCLE');

    setState(() {
      _lifeCycleOptions = options;
    });
  }

  @override
  void initState() {
    super.initState();
    _testLifeCycleLoad();
    _loadSeedTypeObjectType();
    _loadSeedTypeStatus();
  }

  @override
  void dispose() {
    _commonNameController.dispose();
    _varietyController.dispose();
    _botanicalNameController.dispose();
    _descriptionController.dispose();
    _minGermController.dispose();
    _maxGermController.dispose();
    _growingInstController.dispose();
    _minHeightController.dispose();
    _maxHeightController.dispose();
    _minSpaceController.dispose();
    _maxSpaceController.dispose();
    _minGermDayController.dispose();
    _maxGermDayController.dispose();
    _minTransDayController.dispose();
    _maxTransDayController.dispose();
    _minFruitDayController.dispose();
    _maxFruitDayController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      pageTitle: 'Add seed type',
      showBackButton: true,
      pageContent: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16),

            SeedTypeCard(
              commonName: _commonNameController.text,
              variant: _varietyController.text,
              botanicalName: _botanicalNameController.text,
              storagePath: _selectedImage?.storagePath,
              allowImageChange: true,
              onImageChanged: (selectedImage) {
                setState(() {
                  _selectedImage = selectedImage;
                });
              },
            ),

            const SizedBox(height: 32),
            ElnoSectionHeader(headerString: 'Plant Details'),
            const SizedBox(height: 12),

            ElnoTextInput(
              labelText: 'Common name',
              hintText: 'Zinnia..',
              numLines: 1,
              requiredField: true,
              controller: _commonNameController,
            ),
            const SizedBox(height: 12),
            ElnoTextInput(
              labelText: 'Variety',
              hintText: 'Queen lime blush...',
              numLines: 1,
              requiredField: false,
              controller: _varietyController,
            ),
            const SizedBox(height: 12),
            ElnoTextInput(
              labelText: 'Botanical name',
              hintText: 'Zinnia elegans...',
              numLines: 1,
              requiredField: false,
              controller: _botanicalNameController,
            ),

            const SizedBox(height: 24),

            Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),

            const SizedBox(height: 32),

            ExpansionTile(
              title: ElnoSectionHeader(headerString: 'Plant details'),
              initiallyExpanded: false,
              shape: const Border(),
              collapsedShape: const Border(),
              children: [
                const SizedBox(height: 12),
                ElnoTextInput(
                  labelText: 'Description',
                  hintText: 'Vibrant, warm-season annual flowering plants belonging to the daisy family',
                  numLines: 4,
                  requiredField: false,
                  controller: _descriptionController,
                ),

                const SizedBox(height: 12),

                ElnoMdInput(
                  labelText: 'Life cycle',
                  options: _lifeCycleOptions,
                  value: _lifeCycle,
                  onChanged: (newValue) {
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
                  requiredField: false,
                ),
                const SizedBox(height: 12),
                ElnoMinMaxInput(
                  labelText: 'Spacing',
                  minHintText: 'Minimum',
                  maxHintText: 'Maximum',
                  minController: _minSpaceController,
                  maxController: _maxSpaceController,
                  requiredField: false,
                ),

                const SizedBox(height: 24),

                Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),
              ],
            ),

            const SizedBox(height: 32),

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
                  requiredField: false,
                ),

                const SizedBox(height: 12),

                ElnoBoolInput(
                  labelText: 'Stratification required',
                  value: _stratificationRequired,
                  onChanged: (newValue) {
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
                    setState(() {
                      _pinchingRequired = newValue;
                    });
                  },
                  requiredField: false,
                ),

                const SizedBox(height: 12),
                ElnoTextInput(
                  labelText: 'Growing instructions',
                  hintText:
                      'Start 6 to 8 weeks before last frost in seed trays, transplant after danger of frost has passed',
                  numLines: 4,
                  requiredField: false,
                  controller: _growingInstController,
                ),

                const SizedBox(height: 24),

                Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),
              ],
            ),

            const SizedBox(height: 32),

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
                  requiredField: false,
                ),
                const SizedBox(height: 12),
                ElnoMinMaxInput(
                  labelText: 'Transplant days',
                  minHintText: 'Minimum',
                  maxHintText: 'Maximum',
                  minController: _minTransDayController,
                  maxController: _maxTransDayController,
                  requiredField: false,
                ),
                const SizedBox(height: 12),
                ElnoMinMaxInput(
                  labelText: 'Flower/Fruit days',
                  minHintText: 'Minimum',
                  maxHintText: 'Maximum',
                  minController: _minFruitDayController,
                  maxController: _maxFruitDayController,
                  requiredField: false,
                ),

                const SizedBox(height: 24),

                Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),
              ],
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              onPressed: () async {
                final isValid = _formKey.currentState!.validate();

                setState(() {
                  _isSaving = true;
                });
                if (!isValid) {
                  setState(() {
                    _isSaving = false;
                  });
                  return;
                }
                if (isValid) {
                  String? objectUuid;
                  try {
                    objectUuid = await _objectService.createObjectfromType(_seedTypeObjectTypeUuid!);
                    if (!pageContext.mounted) return;
                  } catch (error) {
                    if (!pageContext.mounted) return;
                    ScaffoldMessenger.of(
                      pageContext,
                    ).showSnackBar(AppSnackBar.failed(message: 'Seed could not be created, please try again later'));
                    return;
                  }

                  final seedType = SeedType(
                    seedTypeObjectUuid: objectUuid,
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
                    imageId: _selectedImage?.imageObjectUuid,
                  );

                  try {
                    await _seedTypeService.createSeedType(seedType);
                    if (!pageContext.mounted) return;
                  } catch (error) {
                    if (!pageContext.mounted) return;
                    ScaffoldMessenger.of(
                      pageContext,
                    ).showSnackBar(AppSnackBar.failed(message: 'Seed could not be created, please try again later'));
                  }

                  try {
                    await _evtObjCrudService.createEvtObj(objectUuid, _seedTypeObjectStatusUuid!);
                    if (!pageContext.mounted) return;
                    Navigator.pop(pageContext);
                  } catch (error) {
                    if (!pageContext.mounted) return;
                    ScaffoldMessenger.of(
                      pageContext,
                    ).showSnackBar(AppSnackBar.failed(message: 'Seed could not be created, please try again later'));
                  }

                  _clearForm();
                  setState(() {
                    _isSaving = false;
                  });
                }
              },
              child: _isSaving
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save the seed', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
