import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/seed_sage.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class SeedPacketLotPage extends StatefulWidget {
  final String seedPacketUuid;
  final String lotUuid;
  final String seedTypeUuid;
  final String commonName;
  final String? variety;
  final String? botanicalName;
  final String? storagePath;

  const SeedPacketLotPage({
    super.key,
    required this.seedPacketUuid,
    required this.lotUuid,
    required this.seedTypeUuid,
    required this.commonName,
    this.variety,
    this.botanicalName,
    this.storagePath,
  });

  @override
  State<SeedPacketLotPage> createState() => _SeedPacketLotPage();
}

class _SeedPacketLotPage extends State<SeedPacketLotPage> {
  final DateTime defaultDate = DateTime.now();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventSeedQuantityController = TextEditingController();
  final ElnoMdCrudService _mdGetService = ElnoMdCrudService();
  final LotProcessService _lotProcessService = LotProcessService();
  DateTime? _eventDate;
  bool _hasChanged = false;
  String? _selectedEvent;
  List<ElnoMdOption> _eventOptions = [];
  List<LotHistory> _lotHistoryData = [];
  LotHistory? notSownHistory;
  final _eventFormKey = GlobalKey<FormState>();
  bool _isSaving = false;
  late String _latestLotUuid;
  int _cardRefresh = 0;

  void setChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _hasChanged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _eventDate = defaultDate;
    _latestLotUuid = widget.lotUuid;
    _loadEventOptions();
  }

  // Helper for save on edit
  Future<void> _promptForSave(BuildContext bottomSheetContext) async {
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

                  _latestLotUuid = await _lotProcessService.addLotEvent(
                    parentLotUuid: _latestLotUuid,

                    eventMdUuid: _selectedEvent!,
                    eventDate: _eventDate!,
                    seedQuantity: int.parse(_eventSeedQuantityController.text),
                    seedPacketUuid: widget.seedPacketUuid,
                    seedTypeUuid: widget.seedTypeUuid,
                  );

                  if (!bottomSheetContext.mounted) return;

                  setState(() {
                    _isSaving = false;
                    _hasChanged = false;
                    _cardRefresh++;
                  });
                  _clearEventForm();
                  Navigator.of(bottomSheetContext).pop();

                  await _loadlotHistory();
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

  // Helper for event options
  Future<void> _loadEventOptions() async {
    await _loadlotHistory();
    final options = await _mdGetService.getMdOptionsByType(SeedDefinitions.objectEventsMdType);
    final latestHistory = _lotHistoryData.where((history) => history.lotUuid == _latestLotUuid).firstOrNull;
    final latestLotDisplaySequence = latestHistory?.displaySequence!;
    final validOptions = options.where((options) => options.displaySequence! > latestLotDisplaySequence!).toList();

    if (!mounted) return;

    setState(() {
      _eventOptions = validOptions;
    });
  }

  void _clearEventForm() {
    setState(() {
      _isSaving = false;
      _selectedEvent = null;
      _eventDate = defaultDate;
      _eventSeedQuantityController.clear();
    });
  }

  // Helper to get history
  Future<void> _loadlotHistory() async {
    final options = await _lotProcessService.getLotHistory(
      latestLotUuid: _latestLotUuid,
      seedPacketUuid: widget.seedPacketUuid,
    );

    if (!mounted) return;

    setState(() {
      _lotHistoryData = options;
    });
  }

  // pop up to add event
  void _showAddEvent() {
    final latestHistory = _lotHistoryData.where((history) => history.lotUuid == _latestLotUuid).firstOrNull;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (bottomSheetContext) {
        return PopScope(
          canPop: false,

          onPopInvokedWithResult: (didPop, result) async {
            await _promptForSave((bottomSheetContext));
          },
          child: Form(
            key: _eventFormKey,
            child: SizedBox(
              height: 550,
              width: 350,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add an event', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      // latest
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: '      last recorded details show ',
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '${latestHistory!.remainingQuantity}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFEC799B),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' in stats ',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${latestHistory.eventDisplayValue}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFEC799B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // latest
                      const SizedBox(height: 24),
                      ElnoDateInput(
                        labelText: 'Event Date',
                        requiredField: true,
                        value: _eventDate,
                        hintText: _eventDateController.toString(),
                        minDate: DateTime(1900),
                        maxDate: DateTime.now(),
                        controller: _eventDateController,
                        defaultDate: defaultDate,
                        onDtChanged: (newValue) {
                          setState(() {
                            _eventDate = newValue;
                            _hasChanged = true;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElnoMdInput(
                        labelText: 'Event',
                        options: _eventOptions,
                        hintText: 'select an event...',
                        value: _selectedEvent,
                        onChanged: (newValue) {
                          setChanged(newValue.toString());
                          setState(() {
                            _selectedEvent = newValue;
                            _hasChanged = true;
                          });
                        },
                        requiredField: true,
                      ),

                      const SizedBox(height: 20),
                      ElnoIntInput(
                        labelText: 'Seed count',
                        intHintText: _eventSeedQuantityController.text,
                        intController: _eventSeedQuantityController,
                        requiredField: true,
                        newController: setChanged,
                      ),

                      SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final isValid = _eventFormKey.currentState!.validate();

                            if (!isValid) return;

                            setState(() {
                              _isSaving = true;
                            });
                            try {
                              _latestLotUuid = await _lotProcessService.addLotEvent(
                                parentLotUuid: _latestLotUuid,
                                eventMdUuid: _selectedEvent!,
                                eventDate: _eventDate!,
                                seedQuantity: int.parse(_eventSeedQuantityController.text),
                                seedPacketUuid: widget.seedPacketUuid,
                                seedTypeUuid: widget.seedTypeUuid,
                              );

                              if (!mounted) return;
                              if (!bottomSheetContext.mounted) return;

                              setState(() {
                                _isSaving = false;
                                _hasChanged = false;
                                _cardRefresh++;
                              });

                              Navigator.pop(bottomSheetContext);
                              _clearEventForm();

                              await _loadlotHistory();
                            } catch (error) {
                              debugPrint('CREATE LOT ERROR: $error');

                              if (!mounted) return;
                              if (!bottomSheetContext.mounted) return;
                              setState(() {
                                _isSaving = false;
                              });
                              // ELLEN FIX THIS THE SCAFFOLD MESSANGER IS BEHIND THE BOTTOMODAL THINGIE!!
                              ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                                AppSnackBar.failed(message: error.toString().replaceFirst('Exception: ', '')),
                              );
                            }
                          },
                          child: _isSaving
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Add event', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      SizedBox(height: 44),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext pageContext) {
    final notSownHistory = _lotHistoryData.where((history) => history.eventDisplayValue == 'Not Sown').firstOrNull;
    final sownHistory = _lotHistoryData.where((history) => history.eventDisplayValue == 'Sown').firstOrNull;
    final sproutHistory = _lotHistoryData.where((history) => history.eventDisplayValue == 'Sprouted').firstOrNull;
    final plantedHistory = _lotHistoryData.where((history) => history.eventDisplayValue == 'Planted').firstOrNull;
    final matureHistory = _lotHistoryData.where((history) => history.eventDisplayValue == 'Mature').firstOrNull;
    final completeHistory = _lotHistoryData.where((history) => history.eventDisplayValue == 'Complete').firstOrNull;
    final lostHistory = _lotHistoryData
        .where(
          (history) =>
              history.eventDisplayValue == 'Lost' ||
              history.eventDisplayValue == 'Discarded' ||
              history.eventDisplayValue == 'No germination',
        )
        .firstOrNull;

    return ElnoPageLayout(
      appConfig: appConfig,
      showBackButton: true,
      mainMenu: MainMenu(appConfig: appConfig),
      pageContent: Column(
        children: [
          const SizedBox(height: 16),
          ElnoSectionHeader(headerString: 'History'),
          const SizedBox(height: 16),
          SeedTypeCard(
            key: ValueKey(_cardRefresh),
            commonName: widget.commonName,
            variant: widget.variety,
            botanicalName: widget.botanicalName,
            storagePath: widget.storagePath,
            allowImageChange: false,
            currentObjectUuid: widget.seedPacketUuid,
          ),

          const SizedBox(height: 44),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 42),
            child: Column(
              children: [
                // Not sown
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: notSownHistory == null
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Opacity(
                                  opacity: 0.6,
                                  child: Icon(LucideIcons.beanOff, size: 28, color: Colors.black54),
                                ),

                                const SizedBox(width: 24),

                                const Expanded(
                                  child: Text(
                                    'How in GODS NAME did you get here! Go tell an adult there is a bug',
                                    style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 58, 57, 57)),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.beanOff, size: 28, color: Colors.black54),

                                const SizedBox(width: 24),

                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'on ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(notSownHistory.eventDate!))} :\n',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${notSownHistory.lotQuantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' seeds were ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text: 'added',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' to your inventory',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(width: 1, height: 28, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Sown
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: sownHistory == null
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 0.6,
                                      child: Icon(LucideIcons.bean, size: 28, color: Colors.black54),
                                    ),

                                    const SizedBox(width: 24),

                                    const Expanded(
                                      child: Text(
                                        'no sowings recorded',
                                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 58, 57, 57)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.bean, size: 28, color: Colors.black54),

                                const SizedBox(width: 24),
                                //latestHistory

                                //latestHistory
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'on ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(sownHistory.eventDate!))} :\n',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${sownHistory.lotQuantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' seeds were ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text: 'sown',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(width: 1, height: 28, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Sprouted
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: sproutHistory == null
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 0.6,
                                      child: Icon(LucideIcons.plantPot, size: 28, color: Colors.black54),
                                    ),

                                    const SizedBox(width: 24),

                                    const Expanded(
                                      child: Text(
                                        'no sprouting recorded',
                                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 58, 57, 57)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.plantPot, size: 28, color: Colors.black54),

                                const SizedBox(width: 24),

                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'on ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(sproutHistory.eventDate!))} :\n',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${sproutHistory.lotQuantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' seeds ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text: 'sprouted',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(width: 1, height: 28, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Planted
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: plantedHistory == null
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 0.6,
                                      child: Icon(LucideIcons.sprout, size: 28, color: Colors.black54),
                                    ),

                                    const SizedBox(width: 24),

                                    const Expanded(
                                      child: Text(
                                        'no planting recorded',
                                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 58, 57, 57)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.sprout, size: 28, color: Colors.black54),

                                const SizedBox(width: 24),

                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'on ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(plantedHistory.eventDate!))} :\n',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${plantedHistory.lotQuantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' seeds were ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text: 'planted',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(width: 1, height: 28, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Mature
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: matureHistory == null
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 0.6,
                                      child: Icon(LucideIcons.flower2, size: 28, color: Colors.black54),
                                    ),

                                    const SizedBox(width: 24),

                                    const Expanded(
                                      child: Text(
                                        'no maturity recorded',
                                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 58, 57, 57)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.plantPot, size: 28, color: Colors.black54),

                                const SizedBox(width: 24),

                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'on ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(matureHistory.eventDate!))} :\n',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${matureHistory.lotQuantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' seeds ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text: ' matured',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(width: 1, height: 28, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Complete
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: completeHistory == null
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 0.6,
                                      child: Icon(LucideIcons.leaf, size: 28, color: Colors.black54),
                                    ),

                                    const SizedBox(width: 24),

                                    const Expanded(
                                      child: Text(
                                        'no completed recorded',
                                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 58, 57, 57)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.leaf, size: 28, color: Colors.black54),

                                const SizedBox(width: 24),

                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'on ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              '${DateFormat('dd MMMM yyyy').format(DateTime.parse(completeHistory.eventDate!))} :\n',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${completeHistory.lotQuantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                        const TextSpan(
                                          text: ' seeds ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        const TextSpan(
                                          text: 'completed their life cycle!!',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Opacity(opacity: 0.6, child: Container(width: 200, height: 1, color: Color(0xFFEC799B))),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Lost
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: lostHistory == null
                          ? Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Opacity(
                                      opacity: 0.6,
                                      child: Icon(LucideIcons.ghost, size: 28, color: Color(0xFFEC799B)),
                                    ),

                                    const SizedBox(width: 24),

                                    const Expanded(
                                      child: Text(
                                        'no lost seeds recorded',
                                        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 58, 57, 57)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(LucideIcons.ghost, size: 28, color: Color(0xFFEC799B)),

                                const SizedBox(width: 24),

                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Total loss recorded: ',
                                          style: TextStyle(fontSize: 18, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: '${lostHistory.lotQuantity}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFEC799B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ElnoFab(
        fabIcon: LucideIcons.pencil100,

        actions: [
          ElnoFabAction(fabActionIcon: LucideIcons.calendarPlus, label: 'Add event', onSelected: _showAddEvent),
        ],
      ),
    );
  }
}
