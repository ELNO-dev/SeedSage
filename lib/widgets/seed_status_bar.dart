import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SeedPacketStatusBar extends StatefulWidget {
  final String seedPacketUuid;

  const SeedPacketStatusBar({super.key, required this.seedPacketUuid});
  @override
  State<SeedPacketStatusBar> createState() => _SeedPacketStatusBar();
}

class _SeedPacketStatusBar extends State<SeedPacketStatusBar> {
  @override
  Widget build(BuildContext pageContext) {
    return Column(
      children: [
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
      ],
    );
  }
}
