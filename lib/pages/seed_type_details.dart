import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/models/seed_type.dart';
import '../config/app_config.dart';
import 'main_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../services/seed_type_crud_service.dart';

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
  final SeedTypeService _seedTypeService = SeedTypeService();
  dynamic _lifeCycle;
  List<ElnoMdOption> _lifeCycleOptions = [];

  final _formKey = GlobalKey<FormState>();
  final ElnoMdCrudService _mdService = ElnoMdCrudService();
  final ElnoMdCrudService _mdGetService = ElnoMdCrudService();

  @override
  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  //final String _tmpUUID = '6c63621d-5e80-47a5-a5d8-6a9631f0f55f';
  Map<String, dynamic>? seedType;
  bool _isSaving = false;
  String? _lifeCycleDisplay;
  bool _stratificationRequired = false;
  bool _pinchingRequired = false;

  // Helper to make the sequence run in series not parallel
  Future<void> _loadPageData() async {
    await _loadInitialSeedType();
    await _loadLifeCycleOptions();
    await _loadLifeCycleDisplay();
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
    // debugPrint('LIFECYCLE HELPER FIRED');
    debugPrint(_lifeCycle?.toString());
    if (_lifeCycle == null) return;
    final getDisplayValue = await _mdGetService.getMdDisplayValue(_lifeCycle);

    if (!mounted) return;

    setState(() {
      _lifeCycleDisplay = getDisplayValue;
    });
    debugPrint(getDisplayValue);
    debugPrint('lifeCycle: $_lifeCycle');
  }

  // Helper for lifecycle options
  Future<void> _loadLifeCycleOptions() async {
    final options = await _mdService.getMdOptionsByType('OBJ_SEED_TYPE_LIFE_CYCLE');

    if (!mounted) return;

    setState(() {
      _lifeCycleOptions = options;
    });
    for (final option in _lifeCycleOptions) {
      debugPrint('${option.displayValue} = ${option.uuid}');
    }
  }

  // UI build
  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      mainMenu: MainMenu(appConfig: appConfig),
      pageContent: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Seed Detail', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: double.infinity,
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.4,
                      child: Image.asset('assets/images/frills/border_v1.png', fit: BoxFit.contain),
                    ),
                    Positioned(
                      top: 32,
                      left: 32,
                      child: Text(
                        toTitleCase(_commonNameController.text),
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Positioned(
                      top: 62,
                      left: 32,
                      child: Text(toTitleCase(_varietyController.text), style: TextStyle(fontSize: 20)),
                    ),
                    Positioned(
                      top: 104,
                      left: 32,
                      child: Text(
                        toTitleCase(_botanicalNameController.text),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: ElnoSectionHeader(headerString: 'Seed'),
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
                ),
                const SizedBox(height: 12),
                ElnoTextInput(
                  labelText: 'Variety',
                  hintText: toTitleCase(_varietyController.text),
                  numLines: 1,
                  requiredField: false,
                  controller: _varietyController,
                ),
                const SizedBox(height: 12),
                ElnoTextInput(
                  labelText: 'Botanical name',
                  hintText: toTitleCase(_botanicalNameController.text),
                  numLines: 1,
                  requiredField: false,
                  controller: _botanicalNameController,
                ),

                Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),
              ],
            ),
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
                  hintText: toTitleCase(_descriptionController.text),
                  numLines: 4,
                  requiredField: false,
                  controller: _descriptionController,
                ),
                // Text(_lifeCycleDisplay ?? 'No life cycle'),
                const SizedBox(height: 12),
                ElnoMdInput(
                  labelText: 'Life cycle',
                  options: _lifeCycleOptions,
                  hintText: _lifeCycleDisplay,
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
                const SizedBox(height: 12),
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
                  hintText: toTitleCase(_growingInstController.text),
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
                  if (!pageContext.mounted) return;
                } catch (error) {
                  // Ellen fucked up
                  debugPrint('Ellen fucked up: $error');
                } finally {
                  setState(() {
                    _isSaving = false;
                  });
                }
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
        backgroundColor: const Color(0xFFF6C3D3),
        actions: [
          ElnoFabAction(
            label: 'Delete seed type',

            onSelected: () async {
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
        ],
      ),
    );
  }
}
