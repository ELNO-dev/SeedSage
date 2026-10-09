import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:seedsage/seed_sage.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {
  final SeedTypeListService _seedTypeListService = SeedTypeListService();
  final ElnoMdCrudService _mdService = ElnoMdCrudService();

  List<SeedTypeListData> _seeds = [];
  List<ElnoMdOption> _events = [];

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  Future<void> _loadPageData() async {
    await _loadEvents();
    await _loadSeedTypes();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await _mdService.getAllMdOptionsByType(SeedDefinitions.objectEventsMdType);

      if (!mounted) return;

      setState(() {
        _events = events;
      });
    } catch (error) {
      debugPrint('LANDING PAGE EVENTS ERROR: $error');
    }
  }

  Future<void> _loadSeedTypes() async {
    try {
      final seeds = await _seedTypeListService.getSeedTypes(const SeedTypeListQuery());

      if (!mounted) return;

      setState(() {
        _seeds = seeds;
      });
    } catch (error) {
      debugPrint('LANDING PAGE SEEDS ERROR: $error');
    }
  }

  List<SeedTypeListData> get _filteredSeeds {
    final search = _searchText.trim().toLowerCase();

    if (search.isEmpty) {
      return _seeds;
    }

    return _seeds.where((seed) {
      final commonName = seed.commonName.toLowerCase();
      final variant = (seed.variant ?? '').toLowerCase();

      return commonName.contains(search) || variant.contains(search);
    }).toList();
  }

  int _getEventCount(String eventName) {
    final event = _events.where((option) => option.displayValue.toLowerCase() == eventName.toLowerCase()).firstOrNull;

    if (event == null) return 0;

    return _filteredSeeds.where((seed) => seed.eventUuid == event.uuid).length;
  }

  Widget _buildEventCount(String mdValueUuid, String eventName, Alignment alignment) {
    final count = _getEventCount(eventName);

    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SeedList(selectedFilter: _searchText, selectedEventTypeUuid: mdValueUuid),
            ),
          );
        },
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: eventName,
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '\n',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              TextSpan(
                text: count.toString(),
                style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.w600),
              ),
              /*Text(
        '$eventName ($count)',
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),*/
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

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

                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: const InputDecoration(
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

                _buildEventCount(SeedDefinitions.evtObjEventTypeNotSownUuid, 'Not Sown', const Alignment(0.33, 0.75)),

                _buildEventCount(SeedDefinitions.evtObjEventTypeSowingUuid, 'Sown', const Alignment(-0.57, 0.45)),

                _buildEventCount(
                  SeedDefinitions.evtObjEventTypeGerminationUuid,
                  'Sprouted',
                  const Alignment(0.62, 0.15),
                ),

                _buildEventCount(
                  SeedDefinitions.evtObjEventTypeTransplantUuid,
                  'Planted',
                  const Alignment(-0.65, -0.15),
                ),

                _buildEventCount(
                  SeedDefinitions.evtObjEventTypeFruitingFloweringUuid,
                  'Mature',
                  const Alignment(0.50, -0.45),
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
            onSelected: () async {
              await Navigator.of(pageContext).push(MaterialPageRoute(builder: (context) => const AddSeedType()));

              await _loadSeedTypes();
            },
          ),
        ],
      ),
    );
  }
}
