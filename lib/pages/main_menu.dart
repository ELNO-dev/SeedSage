import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:seedsage/pages/lot_page.dart';
import 'package:seedsage/seed_sage.dart';

class MainMenu extends StatelessWidget {
  final AppConfig appConfig;

  const MainMenu({super.key, required this.appConfig});

  @override
  Widget build(BuildContext mainMenuContext) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(alignment: Alignment.topCenter, child: Image.asset(appConfig.fullLogoAsset, height: 200)),

          ListTile(
            title: const Text('TEMP SEED PACKET STAUS', style: TextStyle(fontSize: 20)),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (seedPacketLotPage) => SeedPacketLotPage(
                    lotUuid: 'e025e13a-b888-4e3d-a41f-64573c3b51e2',
                    seedPacketUuid: 'b99e6116-3a14-4c4c-90e7-c107d39c72aa',
                    seedTypeUuid: '1e44e4f6-3db0-4cc0-b471-f43da5ce216a',
                    commonName: 'Snapdragon',
                    variety: 'Chantilly Bronze with  white throat',
                    botanicalName: 'Antirrhinum majus',
                    storagePath: 'seed_type/525180ee-837a-4e90-878c-4aa795f39f8e.webp',
                  ),
                ),
                (route) => route.isFirst,
              );
            },
          ),

          ListTile(
            title: const Text('View all my seeds', style: TextStyle(fontSize: 20)),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (seedListContext) => SeedList()),
                (route) => route.isFirst,
              );
            },
          ),

          ListTile(
            title: const Text('Your Profile', style: TextStyle(fontSize: 20)),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (userProfileRouteContext) => UserProfilePage(appConfig: appConfig)),
                (route) => route.isFirst,
              );
            },
          ),
          ListTile(
            title: const Text('Terms & Conditions', style: TextStyle(fontSize: 20)),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (termsRouteContext) => TermsPage(appConfig: appConfig)),
                (route) => route.isFirst,
              );
            },
          ),
          ListTile(
            title: const Text('About', style: TextStyle(fontSize: 20)),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (aboutRouteContext) => AboutPage(appConfig: appConfig)),
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),
    );
  }
}
