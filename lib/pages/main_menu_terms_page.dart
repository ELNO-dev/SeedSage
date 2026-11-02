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
          const Text('Terms & Conditions', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),
          const SizedBox(height: 12),

          const Text('Effective date: 10 October 2026', style: TextStyle(fontSize: 12, color: Colors.grey)),

          const SizedBox(height: 24),

          const Text(
            'Welcome to SeedSage, an application developed by ELNO.\n\n'
            'By creating an account or using SeedSage, you agree to these '
            'Terms & Conditions.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 24),

          ...[
            (
              '1. Using SeedSage',
              'SeedSage helps you organise your seed inventory and record '
                  'gardening activities.\n\n'
                  'You agree to use the application lawfully and not interfere '
                  'with its operation or security.',
            ),
            (
              '2. Your account',
              'You are responsible for keeping your login credentials secure '
                  'and for activities performed through your account.\n\n'
                  'You must provide accurate account information and notify us '
                  'if you believe your account has been compromised.',
            ),
            (
              '3. Your information',
              'You retain ownership of the seed records and other content '
                  'you enter into SeedSage.\n\n'
                  'You grant ELNO permission to store and process this information '
                  'as necessary to provide the application.\n\n'
                  'Our Privacy Policy explains how personal information is handled.',
            ),
            (
              '4. Accuracy and availability',
              'SeedSage is provided as a gardening record-keeping tool.\n\n'
                  'We aim to provide a reliable service, but cannot guarantee '
                  'uninterrupted availability, error-free operation, or the '
                  'accuracy of information entered by users.\n\n'
                  'SeedSage does not guarantee germination, plant growth, '
                  'or gardening results.',
            ),
            (
              '5. Changes to the application',
              'We may update, improve, modify or discontinue application '
                  'features. Where appropriate, we will provide notice of '
                  'significant changes.',
            ),
            (
              '6. Deleting your account',
              'You may request or initiate account deletion using the '
                  'available account-management functionality.\n\n'
                  'Deletion of associated information is handled according '
                  'to our Privacy Policy and applicable law.',
            ),
            (
              '7. Intellectual property',
              'The SeedSage application, its design, branding and software '
                  'belong to ELNO or its licensors.\n\n'
                  'Your own seed records remain yours.',
            ),
            (
              '8. Limitation of liability',
              'To the extent permitted by applicable law, ELNO is not '
                  'responsible for indirect losses arising from the use '
                  'or unavailability of SeedSage.\n\n'
                  'Nothing in these terms excludes rights or remedies that '
                  'cannot lawfully be excluded.',
            ),
            (
              '9. Applicable law',
              'These terms are governed by the laws of the Republic of '
                  'South Africa, subject to applicable consumer protection '
                  'requirements.',
            ),
            (
              '10. Contact',
              'For questions about these terms, contact ELNO.\n\n'
                  'Contact details: [Support contact details]',
            ),
            (
              '11. Changes to these terms',
              'We may update these terms periodically. The effective date '
                  'will indicate the current version.\n\n'
                  'Where required, we will notify users and obtain any '
                  'necessary agreement.',
            ),
          ].map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.$1, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(section.$2, style: const TextStyle(fontSize: 14, height: 1.6)),
                  Text(appConfig.tcContent, style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
