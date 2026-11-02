import 'package:flutter/material.dart';
import 'package:foundation/widgets/elno_page_layout.dart';
import 'package:foundation/models/elno_app_config.dart';

class AboutPage extends StatelessWidget {
  final AppConfig appConfig;

  const AboutPage({super.key, required this.appConfig});
  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig!,
      pageContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text('About', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)),
          const SizedBox(height: 24),
          Text(
            'Every little seed has a story.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),

          const SizedBox(height: 24),

          const Text(
            'SeedSage is a simple, thoughtful space to keep track of your seeds '
            'and follow their journey from packet to plant.\n\n'
            'Whether you\'re growing your first sunflower, experimenting with '
            'vegetables, or building a collection of beautiful flowers, '
            'SeedSage helps you remember what you\'ve planted, when you '
            'planted it, and how it\'s growing.\n\n'
            'Keep your seed inventory organised, record important growing '
            'milestones, and look back at the progress you\'ve made.\n\n'
            'Because every growing season is an opportunity to learn. '
            'By looking back at your own experiences, you can discover '
            'what works, what doesn\'t, and what works best for you. '
            'Your garden, your conditions, your discoveries.\n\n'
            'No complicated gardening systems. No pressure to grow '
            'the perfect garden.\n\n'
            'Just you, your seeds, and the joy of learning as you grow.',
            style: TextStyle(fontSize: 14, height: 1.6),
          ),

          const SizedBox(height: 32),

          const Text(
            'Made with love for the little things that grow.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),

          const SizedBox(height: 16),

          Text(appConfig.aContent, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
