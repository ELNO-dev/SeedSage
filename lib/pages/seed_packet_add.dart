import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/seed_sage.dart';

class AddSeedPacket extends StatefulWidget {
  final String seedTypeUuid;
  final String commonName;
  final String? variety;
  final String? botanicalName;
  final String? storagePath;

  const AddSeedPacket({
    super.key,
    required this.seedTypeUuid,
    required this.commonName,
    this.variety,
    this.botanicalName,
    this.storagePath,
  });

  @override
  State<AddSeedPacket> createState() => _AddSeedPacket();
}

class _AddSeedPacket extends State<AddSeedPacket> {
  final TextEditingController _source = TextEditingController();
  final TextEditingController _initialSeedQuantity = TextEditingController();
  final TextEditingController _purchasedDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final SeedPacketProcessService _seedPacketProcessService = SeedPacketProcessService();
  DateTime? _purchaseDate;
  final DateTime defaultDate = DateTime.now();
  bool _isSaving = false;

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
            SeedTypeCard(
              commonName: widget.commonName,
              variant: widget.variety,
              botanicalName: widget.botanicalName,
              storagePath: widget.storagePath,
              allowImageChange: false,
            ),
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
              intHintText: 'seed count',
              intController: _initialSeedQuantity,
              requiredField: false,
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              onPressed: () async {
                final isValid = _formKey.currentState!.validate();

                if (!isValid) return;

                setState(() {
                  _isSaving = true;
                });

                try {
                  await _seedPacketProcessService.createSeedPacketWithInitialLot(
                    seedTypeUuid: widget.seedTypeUuid,
                    source: _source.text,
                    purchaseDate: _purchaseDate!,
                    initialSeedQuantity: int.tryParse(_initialSeedQuantity.text),
                  );

                  if (!mounted) return;

                  _clearForm();

                  setState(() {
                    _isSaving = false;
                  });
                } catch (error) {
                  debugPrint('CREATE SEED PACKET ERROR: $error');

                  if (!mounted) return;

                  setState(() {
                    _isSaving = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    AppSnackBar.failed(message: 'Seed packet could not be created, please try again later'),
                  );
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
