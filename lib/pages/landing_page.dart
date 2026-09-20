import 'package:flutter/material.dart';
import 'package:foundation/widgets/elno_page_layout.dart';
import 'package:foundation/widgets/elno_fab.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:seedsage/pages/seed_type_add.dart';
import '../config/app_config.dart';
import 'main_menu.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      mainMenu: MainMenu(appConfig: appConfig),
      pageContent: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              height: 54,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 30,
                    child: Image.asset('assets/icons/search_flourish.png', fit: BoxFit.fitWidth),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Find a seed...',
                      hintStyle: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Color(0xFFA7A19F)),
                      prefixIcon: Icon(Icons.search, size: 20, color: Color(0xFFA7A19F)),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 0.55,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/backgrounds/VineLanding.png'),
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                      opacity: 0.6,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.33, 0.60),
                  child: Text(
                    'Not sown',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.6, 0.27),
                  child: Text(
                    'Sown',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Align(
                  alignment: Alignment(0.65, 0.01),
                  child: Text(
                    'Sprouted',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.68, -0.3),
                  child: Text(
                    'Planted',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Align(
                  alignment: Alignment(0.50, -0.58),
                  child: Text(
                    'Mature',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: ElnoFab(
        fabIcon: LucideIcons.pencil100,
        actions: [
          ElnoFabAction(
            label: 'Add a seed type',
            fabActionIcon: LucideIcons.sprout,
            onSelected: () {
              Navigator.of(pageContext).push(MaterialPageRoute(builder: (context) => const AddSeedType()));
            },
          ),
        ],
      ),
    );
  }
}
