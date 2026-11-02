import 'package:flutter/material.dart';
import 'package:foundation/widgets/elno_page_layout.dart';
import 'package:foundation/models/elno_app_config.dart';

class PrivacyPage extends StatelessWidget {
  final AppConfig appConfig;

  const PrivacyPage({super.key, required this.appConfig});
  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      pageContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          const Text('Privacy Policy', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          const SizedBox(height: 18),

          Text(appConfig.pContent, style: const TextStyle(fontSize: 20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Privacy Policy', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              const Text('Effective date: 10 October 2026', style: TextStyle(fontSize: 12, color: Colors.grey)),

              const SizedBox(height: 24),

              const Text(
                'SeedSage is developed by ELNO. We respect your privacy '
                'and aim to collect only the information necessary to '
                'operate the application.',
                style: TextStyle(fontSize: 14, height: 1.6),
              ),

              const SizedBox(height: 24),

              ...[
                (
                  '1. Information we collect',
                  'Depending on how you use SeedSage, we may process:\n\n'
                      '• Account information, including your email address '
                      'and authentication identifiers.\n\n'
                      '• Seed inventory information, including seed types, '
                      'packets, quantities and growing events.\n\n'
                      '• Technical and security information necessary to '
                      'operate and protect the application.',
                ),
                (
                  '2. How we use your information',
                  'We process information to:\n\n'
                      '• Create and manage your account.\n\n'
                      '• Save, retrieve and manage your seed records.\n\n'
                      '• Authenticate users and protect accounts.\n\n'
                      '• Maintain, troubleshoot and improve the application.\n\n'
                      '• Comply with applicable legal obligations.',
                ),
                (
                  '3. How your information is stored',
                  'SeedSage uses third-party infrastructure, including '
                      'Supabase, for authentication and data storage.\n\n'
                      'We use access controls intended to prevent users '
                      'from accessing other users\' private seed records.\n\n'
                      'No electronic system can be guaranteed completely secure.',
                ),
                (
                  '4. Sharing your information',
                  'We do not sell your personal information.\n\n'
                      'Information may be processed by service providers '
                      'supporting the operation of SeedSage, or disclosed '
                      'when legally required.',
                ),
                (
                  '5. International data processing',
                  'Some service providers may process or store information '
                      'outside South Africa.\n\n'
                      'Where applicable, ELNO will take steps to ensure '
                      'international transfers comply with the Protection '
                      'of Personal Information Act (POPIA).',
                ),
                (
                  '6. Data retention and deletion',
                  'We retain account and seed information while your '
                      'account is active, or for as long as necessary for '
                      'legitimate operational or legal purposes.\n\n'
                      'You can delete your account using the available '
                      'account-management functionality.\n\n'
                      'Some information may remain temporarily in backups '
                      'or be retained where legally required.',
                ),
                (
                  '7. Your privacy rights',
                  'Subject to applicable law, you may request access to, '
                      'correction of, or deletion of your personal information.\n\n'
                      'You may also raise concerns about how your '
                      'information is processed.\n\n'
                      'Requests can be directed to the contact details below.',
                ),
                (
                  '8. Children\'s privacy',
                  'SeedSage is not intended for children under 18 without '
                      'appropriate parental or guardian involvement.',
                ),
                (
                  '9. Changes to this policy',
                  'We may update this Privacy Policy to reflect changes '
                      'in our services, technology or legal obligations.\n\n'
                      'The effective date will indicate the current version.',
                ),
                (
                  '10. Contact and Information Officer',
                  'ELNO\n\n'
                      'Contact: [Privacy contact details]\n\n'
                      'Information Officer: [Name or designated contact]\n\n'
                      'You may also contact the Information Regulator of '
                      'South Africa regarding your rights under POPIA.',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
