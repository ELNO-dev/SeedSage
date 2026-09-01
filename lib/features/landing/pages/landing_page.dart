import 'package:flutter/material.dart';
import 'package:foundation/widgets/elno_page_layout.dart';

import '../../../config/app_config.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ElnoPageLayout(
      appConfig: appConfig,
      pageContent: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: SizedBox(
              height: 54,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 30,
                    child: Image.asset(
                      'assets/icons/search_flourish.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Find a seed...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFFA7A19F),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20,
                        color: Color(0xFFA7A19F),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}