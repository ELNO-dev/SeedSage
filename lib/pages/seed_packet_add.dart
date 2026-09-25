import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/models/seed_packet.dart';
import '../config/app_config.dart';
import 'package:seedsage/services/seed_packet_crud_service.dart';
import 'package:seedsage/services/object_CRUD_service.dart';

class AddSeedPacket extends StatefulWidget {
  final String seedTypeUuid;
  const AddSeedPacket({super.key, required this.seedTypeUuid});

  @override
  State<AddSeedPacket> createState() => _AddSeedPacket();
}

class _AddSeedPacket extends State<AddSeedPacket> {
  final TextEditingController _source = TextEditingController();
  final TextEditingController _initialSeedQuantity = TextEditingController();
  final TextEditingController _purchasedDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ObjectCrudService _objectService = ObjectCrudService();
  final SeedPacketService _seedPacketService = SeedPacketService();
  DateTime? _purchaseDate;
  final DateTime defaultDate = DateTime.now();
  bool _isSaving = false;
  final String _seedPacketObjectTypeUuid = '4ef66b41-51e1-4ac1-80c9-2031246258c9';

  void _clearForm() {
    _source.clear();
    _initialSeedQuantity.clear();
    _formKey.currentState?.reset();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _source.dispose();
    _initialSeedQuantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      pageTitle: 'Add seed packet',
      showBackButton: true,
      pageContent: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 32),
            ElnoSectionHeader(headerString: 'Seed packet details'),
            const SizedBox(height: 12),
            ElnoTextInput(
              labelText: 'Seed source',
              hintText: 'Enter the brand/ grower/ source',
              numLines: 1,
              requiredField: false,
              controller: _source,
            ),
            const SizedBox(height: 12),
            ElnoDateInput(
              labelText: 'Purchased Date',
              requiredField: true,
              value: _purchaseDate,
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
              intHintText: 'seed count',
              intController: _initialSeedQuantity,
              requiredField: false,
            ),
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
                    objectUuid = await _objectService.createObjectfromType(_seedPacketObjectTypeUuid);
                    debugPrint('Seed packet UUID: $objectUuid');
                    if (!pageContext.mounted) return;
                  } catch (error) {
                    if (!pageContext.mounted) return;
                    ScaffoldMessenger.of(pageContext).showSnackBar(
                      AppSnackBar.failed(message: 'Seed packet could not be created, please try again later'),
                    );
                    return;
                  }

                  final seedPacket = SeedPacket(
                    seedPacketObjectUuid: objectUuid,
                    seedTypeUuid: widget.seedTypeUuid,
                    source: _source.text,
                    purchaseDate: _purchaseDate,
                    initialSeedQuantity: int.tryParse(_initialSeedQuantity.text),
                  );
                  try {
                    await _objectService.createObjectfromType(_seedPacketObjectTypeUuid);
                    debugPrint('Seed packet UUID: $objectUuid');
                    if (!pageContext.mounted) return;
                  } catch (error) {
                    if (!pageContext.mounted) return;
                    ScaffoldMessenger.of(pageContext).showSnackBar(
                      AppSnackBar.failed(message: 'Seed packet could not be created, please try again later'),
                    );
                    return;
                  }
                  _clearForm();
                  setState(() {
                    _isSaving = false;
                  });
                }
              },
              child: _isSaving
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save seed packet', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
