import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import '../../../config/app_config.dart';
import 'select_seed_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/seed_image.dart';

class AddSeedType extends StatefulWidget {
  const AddSeedType({super.key});

  @override
  State<AddSeedType> createState() => _AddSeedTypeState();
}

class _AddSeedTypeState extends State<AddSeedType> {
  final TextEditingController _commonNameController = TextEditingController();
  final TextEditingController _varietyController = TextEditingController();
  final TextEditingController _botanicalNameController =
      TextEditingController();
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

  final ElnoMdService _mdService = ElnoMdService();
  bool _stratificationRequired = false;
  bool _pinchingRequired = false;
  String? _lifeCycle;
  List<ElnoMdOption> _lifeCycleOptions = [];
  SeedImage? _selectedImage;
  String? _seedTypeObjectTypeUuid;
  String? _seedTypeObjectStatusUuid;
  bool _isSaving = false;

  Future<void> _loadSeedTypeObjectType() async {
    final options = await _mdService.getOptions('OBJ_OBJECT_TYPE');

    final seedTypeOption = options.firstWhere(
      (option) => option.valueCode == 'OBJ_OBJECT_TYPE_SEED_TYPE',
    );

    setState(() {
      _seedTypeObjectTypeUuid = seedTypeOption.uuid;
    });
  }

  Future<void> _loadSeedTypeStatus() async {
    final options = await _mdService.getOptions('OBJ_STATUS');

    final seedTypeStatus = options.firstWhere(
      (option) => option.valueCode == 'OBJ_STATUS_NOT_SOWN',
    );

    setState(() {
      _seedTypeObjectStatusUuid = seedTypeStatus.uuid;
    });
  }

  Future<void> _testLifeCycleLoad() async {
    final options = await _mdService.getOptions('OBJ_SEED_TYPE_LIFE_CYCLE');

    setState(() {
      _lifeCycleOptions = options;
    });
    // debugPrint('Life cycle option count: ${_lifeCycleOptions.length}');
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () async {
                  final selectedImage = await Navigator.of(pageContext)
                      .push<SeedImage>(
                        MaterialPageRoute(
                          builder: (context) => const SearchSeedImage(),
                        ),
                      );

                  setState(() {
                    _selectedImage = selectedImage;
                  });
                },
                child: SizedBox(
                  height: 220,
                  child: _selectedImage == null
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
                      : Image.asset(
                          _selectedImage!.assetPath,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
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

            Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/frills/long_frill.png',
                fit: BoxFit.contain,
              ),
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
                  hintText:
                      'Vibrant, warm-season annual flowering plants belonging to the daisy family',
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

                Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    'assets/images/frills/long_frill.png',
                    fit: BoxFit.contain,
                  ),
                ),
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

                Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    'assets/images/frills/long_frill.png',
                    fit: BoxFit.contain,
                  ),
                ),
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

                Opacity(
                  opacity: 0.4,
                  child: Image.asset(
                    'assets/images/frills/long_frill.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
              ),
              onPressed: () async {
                final isValid = _formKey.currentState!.validate();

                setState(() {
                  _isSaving = true;
                });

                if (isValid) {
                  final response = await Supabase.instance.client
                      .from('obj_object')
                      .insert({'object_type_uuid': _seedTypeObjectTypeUuid})
                      .select('object_uuid')
                      .single();
                  final objectUuid = response['object_uuid'];

                  debugPrint('OBJECT CREATED: ${response['object_uuid']}');

                  await Supabase.instance.client.from('obj_seed_type').insert({
                    'seed_type_object_uuid': objectUuid,
                    'common_name': _commonNameController.text.trim(),
                    'variant': _varietyController.text.trim(),
                    'botanical_name': _botanicalNameController.text.trim(),
                    'description': _descriptionController.text.trim(),
                    'min_germination_temperature_c': int.tryParse(
                      _minGermController.text,
                    ),
                    'max_germination_temperature_c': int.tryParse(
                      _maxGermController.text,
                    ),
                    'growing_instructions': _growingInstController.text.trim(),
                    'min_height_cm': int.tryParse(_minHeightController.text),
                    'max_height_cm': int.tryParse(_maxHeightController.text),
                    'min_spacing_cm': int.tryParse(_minSpaceController.text),
                    'max_spacing_cm': int.tryParse(_maxSpaceController.text),

                    'stratification_required': _stratificationRequired,
                    'pinching_required': _pinchingRequired,

                    'min_germination_days': int.tryParse(
                      _minGermDayController.text,
                    ),
                    'max_germination_days': int.tryParse(
                      _maxGermDayController.text,
                    ),

                    'min_transplant_days': int.tryParse(
                      _minTransDayController.text,
                    ),
                    'max_transplant_days': int.tryParse(
                      _maxTransDayController.text,
                    ),

                    'min_flower_fruit_days': int.tryParse(
                      _minFruitDayController.text,
                    ),
                    'max_flower_fruit_days': int.tryParse(
                      _maxFruitDayController.text,
                    ),
                    'life_cycle_uuid': _lifeCycle,
                    'image_id': _selectedImage?.id,
                  });

                  await Supabase.instance.client.from('evt_obj').insert({
                    'object_uuid': objectUuid,
                    'event_type_uuid': _seedTypeObjectStatusUuid,
                    'event_date': DateTime.now().toIso8601String(),
                  });

                  debugPrint('SEED TYPE CREATED - ');
                  debugPrint(_lifeCycle);

                  _clearForm();
                  setState(() {
                    _isSaving = false;
                  });
                }
              },
              child: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save the seed', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
