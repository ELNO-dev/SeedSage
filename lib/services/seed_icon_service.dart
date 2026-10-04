import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SeedIconService {
  static IconData getIcon(String? iconCode) {
    switch (iconCode) {
      case 'beanOff':
        return LucideIcons.beanOff;
      case 'bean':
        return LucideIcons.bean;
      case 'plantPot':
        return LucideIcons.plantPot;
      case 'sprout':
        return LucideIcons.sprout;
      case 'flower2':
        return LucideIcons.flower2;
      case 'leaf':
        return LucideIcons.leaf;
      case 'ghost':
        return LucideIcons.ghost;
      default:
        return LucideIcons.circleHelp;
    }
  }
}
