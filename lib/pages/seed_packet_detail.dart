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

  @override
  void initState() {
    super.initState();
    _loadInitialSeedPacket();
  }

  // Helper to get the name
  Future<void> _loadInitialSeedPacket() async {
    final initialSeedPacket = await _seedPacketService.getSeedPacketFromUuid(widget.seedPacketUuid);

    if (!mounted) return;
    debugPrint('Seed packet in helper: ${initialSeedPacket.source}');
    setState(() {
      _sourceController.text = initialSeedPacket.source ?? '';
      _initialSeedQuantityController.text = (initialSeedPacket.initialSeedQuantity).toString();
      _purchasedDateController.text = initialSeedPacket.purchaseDate!.toIso8601String().split('T').first;
    });
  }

  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      showBackButton: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(LucideIcons.beanOff, size: 28, color: Colors.black54),
                      const SizedBox(height: 6),
                      const Text('Not\nSown', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text('22', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(LucideIcons.bean, size: 28, color: Colors.black54),
                      const SizedBox(height: 6),
                      const Text('Sown', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text('8', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(LucideIcons.plantPot, size: 28, color: Colors.black54),
                      const SizedBox(height: 6),
                      const Text('Sprouted', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text('6', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(LucideIcons.sprout, size: 28, color: Colors.black54),
                      const SizedBox(height: 6),
                      const Text('Planted', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text('4', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(LucideIcons.flower2, size: 28, color: Colors.black54),
                      const SizedBox(height: 6),
                      const Text('Mature', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text('2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(LucideIcons.leaf, size: 28, color: Colors.black54),
                      const SizedBox(height: 6),
                      const Text('Done', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      const Text('1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(LucideIcons.ghost, size: 22, color: Color(0xFFEC799B)),
                const SizedBox(width: 6),
                const Text('Lost', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                const Text('3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
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
                    });
                  },
                ),

                const SizedBox(height: 12),

                ElnoIntInput(
                  labelText: 'Initial seed count',
                  intHintText: _initialSeedQuantityController.text,
                  intController: _initialSeedQuantityController,
                  requiredField: false,
                ),

                const SizedBox(height: 36),
              ], // ExpansionTile children
            ), // ExpansionTile
          ], // Column children
        ), // Column
      ), // Form
    ); // ElnoPageLayout
  } // build
} // _SeedPacketState
