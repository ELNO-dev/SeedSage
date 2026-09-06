import 'package:flutter/material.dart';
import 'package:foundation/models/elno_app_config.dart';
import 'package:foundation/pages/user_profile_page.dart';
import '../pages/about_page.dart';
import '../pages/terms_page.dart';
import '../../seed_type/pages/seed_list_view.dart';
import '../../seed_type/pages/seed_type_details.dart';

class MainMenu extends StatelessWidget {
  final AppConfig appConfig;

  const MainMenu({super.key, required this.appConfig});

  @override
  Widget build(BuildContext mainMenuContext) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(appConfig.fullLogoAsset, height: 200),
          ),
          

          ListTile(
            title: const Text(
              'View my seeds',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (seedListContext) =>
                      SeedList(),
                ),
                (route) => route.isFirst,
              );
            },
          ),

        ListTile(
            title: const Text(
              'Seed detail',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (seedDetailContext) =>
                      SeedDetail(),
                ),
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
                MaterialPageRoute(
                  builder: (userProfileRouteContext) =>
                      UserProfilePage(appConfig: appConfig),
                ),
                (route) => route.isFirst,
              );
            },
          ),
          ListTile(
            title: const Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              final navigator = Navigator.of(mainMenuContext);

              navigator.pop();

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (termsRouteContext) =>
                      TermsPage(appConfig: appConfig),
                ),
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
                MaterialPageRoute(
                  builder: (aboutRouteContext) =>
                      AboutPage(appConfig: appConfig),
                ),
                (route) => route.isFirst,
              );
            },
          ),
        ],
      ),
    );
  }
}
