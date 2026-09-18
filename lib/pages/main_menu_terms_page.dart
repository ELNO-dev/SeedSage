import 'package:flutter/material.dart';
import 'package:foundation/widgets/elno_page_layout.dart';
import 'package:foundation/models/elno_app_config.dart';

class TermsPage extends StatelessWidget {
  final AppConfig appConfig;
  const TermsPage({super.key, required this.appConfig});
  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      pageContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          const Text(
            'Terms & Conditions',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Text(appConfig.tcContent, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
