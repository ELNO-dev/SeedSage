import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import '../../../config/app_config.dart';
import '../../main_menu/pages/main_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeedDetail extends StatefulWidget {
  const SeedDetail({super.key});

  @override
  State<SeedDetail> createState() => _SeedDetail();
}

class _SeedDetail extends State<SeedDetail> {
final SupabaseClient _supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    getSeedName();
  }

final String _tmpUUID = '6c63621d-5e80-47a5-a5d8-6a9631f0f55f';
Map<String, dynamic>? commonName;

// Helper to get the name
Future<void> getSeedName() async {
  


    final cmnName = await _supabase
    .from('obj_seed_type')
    .select('common_name')
    .eq('seed_type_object_uuid', _tmpUUID)
    .maybeSingle();
     debugPrint('Found name: $_tmpUUID'); 
    debugPrint('Found name: $cmnName');  

   setState(() {
      commonName = cmnName;
    });
debugPrint('Found name: $commonName');  
}


// UI build
Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      mainMenu: MainMenu(
        appConfig: appConfig,
      ),
      pageContent: Column(
        children:[
          Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: Stack(
          children: [
                Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/images/frills/border_v1.png',
                  fit: BoxFit.contain,
                ),
              ),
             Positioned(
          top: 32,
          left: 32,
          child:  Text(
            commonName?['common_name'] ?? '',
            style: TextStyle(
              fontSize: 28, 
            ),
          ),
            ),  
        ]
        ),
        ),
        ),
        ]
          ),
      );
}

}
