import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:seedsage/features/seed_type/pages/add_seed_type.dart';

import '../../../config/app_config.dart';
import '../../../models/seed_type_list_data.dart';
import '../../main_menu/pages/main_menu.dart';
import '../services/seed_type_list_service.dart';

class SeedList extends StatefulWidget {
  const SeedList({super.key});

  @override
  State<SeedList> createState() => _SeedListState();
}

class _SeedListState extends State<SeedList> {
  final ElnoMdService _mdService = ElnoMdService();
  final SeedTypeListService _seedTypeListService = SeedTypeListService();

  List<ElnoMdOption> _statuses = [];
  List<SeedTypeListData> _seeds = [];

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  Future<void> _loadPageData() async {
    await _loadSeedTypeStatuses();
    await _loadSeedTypes();
  }

  Future<void> _loadSeedTypeStatuses() async {
    final options = await _mdService.getOptions('OBJ_STATUS');

    if (!mounted) return;

    setState(() {
      _statuses = options;
    });
  }

  Future<void> _loadSeedTypes() async {
    try {
      final seeds = await _seedTypeListService.getSeedTypes(
        const SeedTypeListQuery(),
      );

      if (!mounted) return;

      setState(() {
        _seeds = seeds;
      });
    } catch (e) {
      debugPrint('SEED LIST ERROR: $e');
    }
  }

  ElnoMdOption? _findStatusByName(String statusName) {
    for (final status in _statuses) {
      if (status.displayValue.toLowerCase() == statusName.toLowerCase()) {
        return status;
      }
    }

    return null;
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

  int get _notSownCount {
    final notSownStatus = _findStatusByName('Not sown');

    if (notSownStatus == null) {
      return 0;
    }

    return _seeds
        .where(
          (seed) => seed.statusUuid == notSownStatus.uuid,
        )
        .length;
  }

  int get _sownCount {
    final notSownStatus = _findStatusByName('Not sown');
    final doneStatus = _findStatusByName('Done');
    final lostStatus = _findStatusByName('Lost');

    return _seeds.where((seed) {
      if (seed.statusUuid == null) {
        return false;
      }

      if (notSownStatus != null &&
          seed.statusUuid == notSownStatus.uuid) {
        return false;
      }

      if (doneStatus != null &&
          seed.statusUuid == doneStatus.uuid) {
        return false;
      }

      if (lostStatus != null &&
          seed.statusUuid == lostStatus.uuid) {
        return false;
      }

      return true;
    }).length;
  }

  Widget _buildSeedCard(SeedTypeListData seed) {
    final hasVariant =
        seed.variant != null && seed.variant!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 5,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              seed.commonName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (hasVariant) ...[
              const SizedBox(height: 2),
              Text(
                seed.variant!,
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF77706E),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusExpansion(ElnoMdOption status) {
    final matchingSeeds = _filteredSeeds
        .where(
          (seed) => seed.statusUuid == status.uuid,
        )
        .toList();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ExpansionTile(
          title: const SizedBox(height: 40),
          initiallyExpanded: false,
          shape: const Border(),
          collapsedShape: const Border(),
          children: [
            const SizedBox(height: 24),

            ...matchingSeeds.map(
              (seed) => _buildSeedCard(seed),
            ),

            if (matchingSeeds.isEmpty)
              const Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 10,
                ),
                child: Text(
                  'No seeds',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFFA7A19F),
                  ),
                ),
              ),
          ],
        ),

        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: ElnoSectionHeader(
                headerString: status.displayValue,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalCard({
    required String label,
    required int count,
  }) {
    return Expanded(
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFBD5DC).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 1),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext pageContext) {
    return ElnoPageLayout(
      appConfig: appConfig,
      mainMenu: MainMenu(
        appConfig: appConfig,
      ),
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
                    child: Image.asset(
                      'assets/icons/search_flourish.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                    decoration: const InputDecoration(
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

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildTotalCard(
                  label: 'Not Sown',
                  count: _notSownCount,
                ),

                const SizedBox(width: 24),

                _buildTotalCard(
                  label: 'Sown',
                  count: _sownCount,
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/images/frills/long_frill.png',
              fit: BoxFit.fitWidth,
            ),
          ),

          ..._statuses.map(
            (status) => _buildStatusExpansion(status),
          ),
        ],
      ),
      floatingActionButton: ElnoFab(
        fabIcon: LucideIcons.pencil100,
        actions: [
          ElnoFabAction(
            label: 'Add a seed type',
            onSelected: () {
              Navigator.of(pageContext).push(
                MaterialPageRoute(
                  builder: (context) => const AddSeedType(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}