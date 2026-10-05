import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:seedsage/seed_sage.dart';

class SeedPacketDetail extends StatefulWidget {
  final String seedPacketUuid;
  final String seedTypeUuid;
  final String commonName;
  final String? variety;
  final String? botanicalName;
  final String? storagePath;

  const SeedPacketDetail({
    super.key,
    required this.seedPacketUuid,
    required this.seedTypeUuid,
    required this.commonName,
    this.variety,
    this.botanicalName,
    this.storagePath,
  });
  @override
  State<SeedPacketDetail> createState() => _SeedPacketState();
}

class _SeedPacketState extends State<SeedPacketDetail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _initialSeedQuantityController = TextEditingController();
  final TextEditingController _purchasedDateController = TextEditingController();
  DateTime? _purchaseDate;
  final DateTime defaultDate = DateTime.now();
  final SeedPacketService _seedPacketService = SeedPacketService();
  final LotCrudService _lotCrudService = LotCrudService();
  final SeedPacketProcessService _seedPacketProcessService = SeedPacketProcessService();
  bool _hasChanged = false;
  bool _isSaving = false;
  List<LotSummary> _lotSummaries = [];

  @override
  void initState() {
    super.initState();
    _loadInitialSeedPacket();
    _loadlotSummaries();
  }

  // Helper to get seed lot summaries
  Future<void> _loadlotSummaries() async {
    final openLots = await _lotCrudService.getAllOpenLotsFromPacket(widget.seedPacketUuid);

    if (!mounted) return;

    setState(() {
      _lotSummaries = openLots;
    });
  }

  // Helper to build seed packet lot cards
  Widget _buildLotCard(LotSummary lotSummary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SeedPacketLotPage(
                seedTypeUuid: widget.seedTypeUuid,
                lotUuid: lotSummary.lotUuid,
                seedPacketUuid: widget.seedPacketUuid,
                commonName: widget.commonName,
                variety: widget.variety,
                botanicalName: widget.botanicalName,
                storagePath: widget.storagePath,
              ),
            ),
          );

          await _loadlotSummaries();
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
                    Row(
                      children: [
                        Icon(SeedIconService.getIcon(lotSummary.eventIconCode), size: 28, color: Colors.black54),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'as of ${lotSummary.latestEventDate} you have ',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                                TextSpan(
                                  text: '${lotSummary.remainingQuantity}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC799B)),
                                ),
                                TextSpan(
                                  text: ' ${lotSummary.latestEventDisplayValue?.toLowerCase()}',
                                  style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: ' from this packet.',
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
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

  // Helper to confirm deletion of seed packet

  Future<bool> _confirmSeedPacketDeletion() async {
    final bool? userConfirmed = await showDialog<bool>(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete the seed packet?'),

          content: const Text(
            'This permanently deletes the seed packet and '
            'all events and cannot be undone.',
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

  // Helper to set change variable

  void setChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _hasChanged = true;
      });
    }
  }

  Future<void> _saveSeedPacket() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    setState(() {
      _isSaving = true;
    });

    final updateSeedPacket = SeedPacket(
      seedPacketObjectUuid: widget.seedPacketUuid,
      seedTypeUuid: widget.seedTypeUuid,
      source: _sourceController.text,
      purchaseDate: DateTime.tryParse(_purchasedDateController.text),
      initialSeedQuantity: int.tryParse(_initialSeedQuantityController.text),
    );

    try {
      await _seedPacketService.updateSeedPacket(updateSeedPacket);
    } catch (error) {
      // Ellen fucked up

      debugPrint('Ellen fucked up: $error');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  // Helper to get the name
  Future<void> _loadInitialSeedPacket() async {
    final initialSeedPacket = await _seedPacketService.getSeedPacketFromUuid(widget.seedPacketUuid);

    if (!mounted) return;

    setState(() {
      _sourceController.text = initialSeedPacket.source ?? '';
      _initialSeedQuantityController.text = (initialSeedPacket.initialSeedQuantity).toString();
      _purchasedDateController.text = initialSeedPacket.purchaseDate!.toIso8601String().split('T').first;
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

                  await _saveSeedPacket();

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
              ElnoSectionHeader(headerString: 'Seed packet details'),
              SeedTypeCard(
                commonName: widget.commonName,
                variant: widget.variety,
                botanicalName: widget.botanicalName,
                storagePath: widget.storagePath,
                allowImageChange: false,
              ),
              const SizedBox(height: 14),
              SeedPacketStatusBar(seedPacketUuid: widget.seedPacketUuid),

              const SizedBox(height: 14),

              ExpansionTile(
                title: ElnoSectionHeader(headerString: 'Seed Packet details'),
                initiallyExpanded: false,
                shape: const Border(),
                collapsedShape: const Border(),
                children: [
                  const SizedBox(height: 12),

                  ElnoTextInput(
                    labelText: 'Seed source',
                    hintText: toTitleCase(_sourceController.text),
                    numLines: 1,
                    requiredField: false,
                    controller: _sourceController,
                    newController: setChanged,
                  ),

                  const SizedBox(height: 12),

                  ElnoDateInput(
                    labelText: 'Purchased Date',
                    requiredField: true,
                    value: _purchaseDate,
                    hintText: _purchasedDateController.toString(),
                    minDate: DateTime(1900),
                    maxDate: DateTime.now(),
                    controller: _purchasedDateController,
                    defaultDate: defaultDate,
                    onDtChanged: (newValue) {
                      setState(() {
                        _purchaseDate = newValue!;
                        _hasChanged = true;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  ElnoIntInput(
                    labelText: 'Initial seed count',
                    intHintText: _initialSeedQuantityController.text,
                    intController: _initialSeedQuantityController,
                    requiredField: false,
                    newController: setChanged,
                  ),

                  const SizedBox(height: 36),
                ], // ExpansionTile children
              ),

              ExpansionTile(
                title: ElnoSectionHeader(headerString: 'Seed Packets Statusses'),

                initiallyExpanded: false,

                shape: const Border(),

                collapsedShape: const Border(),

                children: [
                  const SizedBox(height: 24),

                  ..._lotSummaries.map((lot) => _buildLotCard(lot)),

                  if (_lotSummaries.isEmpty)
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

              Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),

                  backgroundColor: _hasChanged ? const Color(0xFFF6C3D3) : const Color(0xFFFFFFFF),
                ),

                onPressed: () async {
                  await _saveSeedPacket();

                  _hasChanged = false;
                },

                child: _isSaving
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Update the seed', style: TextStyle(fontSize: 20)),
              ),
              SizedBox(height: 32),
            ], // Column children
          ),
          // Column
        ), // Form
        floatingActionButton: ElnoFab(
          fabIcon: LucideIcons.pencil100,

          actions: [
            ElnoFabAction(
              fabActionIcon: LucideIcons.trash,

              label: 'Delete seed packet',

              onSelected: () async {
                final bool userConfirmed = await _confirmSeedPacketDeletion();

                if (!userConfirmed) {
                  return;
                }

                try {
                  await _seedPacketProcessService.deleteSeedPacket(widget.seedPacketUuid);

                  if (!pageContext.mounted) return;

                  Navigator.pop(pageContext);
                } catch (error) {
                  if (!pageContext.mounted) return;

                  ScaffoldMessenger.of(pageContext).showSnackBar(
                    AppSnackBar.failed(message: 'Seed packet could not be deleted, please try again later'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
