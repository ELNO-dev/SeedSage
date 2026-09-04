import 'package:flutter/material.dart';
import '../../../config/app_config.dart';
import '../../../config/seed_image_index.dart';
import 'package:foundation/foundation.dart';

class SearchSeedImage extends StatefulWidget {
  const SearchSeedImage({super.key});

  @override
  State<SearchSeedImage> createState() => _SearchSeedImageState();
}

class _SearchSeedImageState extends State<SearchSeedImage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext pageContext) {
    final searchText = _searchController.text.toLowerCase();

    final filteredImages = seedImages.where((image) {
      return image.id.toLowerCase().contains(searchText);
    }).toList();

    return ElnoPageLayout(
      appConfig: appConfig,
      pageTitle: 'Search for an image',
      showBackButton: true,
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
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Find a seed image...',
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
          const SizedBox(height: 16),
          ...filteredImages.map((image) {
            return ListTile(
              leading: SizedBox(
                width: 70,
                height: 70,
                child: Image.asset(image.assetPath, fit: BoxFit.contain),
              ),
              title: Text(image.id),
              onTap: () {
                Navigator.pop(pageContext, image);
              },
            );
          }),
        ],
      ),
    );
  }
}
