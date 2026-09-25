/*import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'main_menu.dart';
import '../config/app_config.dart';

class SeedPacketDetail extends StatefulWidget {
  final String seedPacketUuid;
  const SeedPacketDetail({super.key, required this.seedPacketUuid});

  @override
  State<SeedPacketDetail> createState() => _SeedPacketState();
}

class _SeedPacketState extends State<SeedPacketDetail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _source = TextEditingController();
  final TextEditingController _purchaseDate = TextEditingController();
  final TextEditingController _initialSeedQuantity = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext pageContext) {
    ElnoPageLayout(
      appConfig: appConfig,
      showBackButton: true,
      mainMenu: MainMenu(appConfig: appConfig),
      pageContent: Form(
        key: _formKey,
        child: ExpansionTile(
          title: ElnoSectionHeader(headerString: 'Plant detail'),
          initiallyExpanded: false,
          shape: const Border(),
          collapsedShape: const Border(),
          children: [
            ElnoTextInput(
              labelText: 'Common name',
              hintText: toTitleCase(_source.text),
              numLines: 1,
              requiredField: true,
              controller: _source,
              //  newController: setChanged,
            ),
            const SizedBox(height: 12),
            ElnoTextInput(
              labelText: 'Variety',
              hintText: toTitleCase(_purchaseDate.text),
              numLines: 1,
              requiredField: false,
              controller: _purchaseDate,
              // newController: setChanged,
            ),
            const SizedBox(height: 12),
            ElnoTextInput(
              labelText: 'Botanical name',
              hintText: toTitleCase(_initialSeedQuantity.text),
              numLines: 1,
              requiredField: false,
              controller: _initialSeedQuantity,
              // newController: setChanged,
            ),
            const SizedBox(height: 24),

            Opacity(opacity: 0.4, child: Image.asset('assets/images/frills/long_frill.png', fit: BoxFit.contain)),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
*/
