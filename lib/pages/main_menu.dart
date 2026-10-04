import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
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
