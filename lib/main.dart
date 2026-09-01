import 'package:flutter/material.dart';
import 'package:foundation/widgets/elno_page_layout.dart';
import 'config/app_theme.dart';
import 'config/app_config.dart';
import 'package:foundation/widgets/landing_router.dart';
import 'features/landing/pages/landing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: appConfig.supabaseUrl,
    publishableKey: appConfig.supabasePublishableKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    home: LandingRouter(
      appConfig: appConfig,
      authenticatedHome: const LandingPage(),
    ),
  );
}
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ElnoPageLayout(
      appConfig: appConfig,
      pageContent: const SizedBox.shrink(),
    );
  }
}