import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:seedsage/seed_sage.dart';

class SeedPacketStatusBar extends StatelessWidget {
  final SeedPacketQtySummary seedPacketQty;

  const SeedPacketStatusBar({super.key, required this.seedPacketQty});
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
                  Text(
                    seedPacketQty.notSownQty.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
                  Text(seedPacketQty.sownQty.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  Text(
                    seedPacketQty.sproutedQty.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
                  Text(
                    seedPacketQty.plantedQty.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
                  Text(seedPacketQty.matureQty.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  Text(seedPacketQty.doneQty.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            Text(seedPacketQty.lostQty.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
