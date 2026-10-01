import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/seed_sage.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
  DateTime? _eventDate;
  bool _hasChanged = false;
  String? _selectedEvent;
  List<ElnoMdOption> _eventOptions = [];

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
    _loadEventOptions();
  }

  // Helper for event options

  Future<void> _loadEventOptions() async {
    final options = await _mdGetService.getMdOptionsByType('EVT_OBJ_EVENT_TYPE');

    if (!mounted) return;

    setState(() {
      _eventOptions = options;
    });
  }

  // pop up to add event
  void _showAddEvent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: 450,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add an event', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

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
                  onDtChanged: (newValue) {},
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
                    });
                  },
                  requiredField: false,
                ),

                const SizedBox(height: 20),
                ElnoIntInput(
                  labelText: 'Initial seed count',
                  intHintText: _eventSeedQuantityController.text,
                  intController: _eventSeedQuantityController,
                  requiredField: false,
                  newController: setChanged,
                ),
                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Add event'),
                  ),
                ),
                SizedBox(height: 38),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext pageContext) {
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
            commonName: widget.commonName,
            variant: widget.variety,
            botanicalName: widget.botanicalName,
            storagePath: widget.storagePath,
            allowImageChange: false,
          ),

          const SizedBox(height: 44),
          Padding(
            padding: EdgeInsets.only(left: 5, right: 5, bottom: 42),
            child: Column(
              children: [
                Container(
                  child: Row(
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
                              const TextSpan(
                                text: '1 February 2026:\n',
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '200',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                              const TextSpan(
                                text: ' seeds were ',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: 'added',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(width: 1, height: 28, color: Colors.black),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    children: [
                      Icon(LucideIcons.bean, size: 28, color: Colors.black54),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'on ',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: '31 February 2026:\n',
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '22',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                              const TextSpan(
                                text: ' of your seeds ',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: 'were sown',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(LucideIcons.plantPot, size: 28, color: Colors.black54),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'on ',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: '4 March 2026:\n',
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '11',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                              const TextSpan(
                                text: ' of your seeds ',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: 'sprouted',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(LucideIcons.sprout, size: 28, color: Colors.black54),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'on ',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: '38 April 2026:\n',
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '11',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                              const TextSpan(
                                text: ' of your seeds were',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: 'planted',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(LucideIcons.flower2, size: 28, color: Colors.black54),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'on ',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: '8 May 2026:\n',
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text: '11',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                              const TextSpan(
                                text: ' of your seeds were',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                              const TextSpan(
                                text: 'mature',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                              ),
                              const TextSpan(
                                text: ' and bearing',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Opacity(opacity: 0.6, child: Icon(LucideIcons.leaf, size: 28, color: Colors.black54)),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Your seeds have not reached ',
                                style: TextStyle(fontSize: 18, color: Colors.black54),
                              ),
                              const TextSpan(
                                text: 'completion',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
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
