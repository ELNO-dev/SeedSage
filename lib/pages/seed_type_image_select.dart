import 'package:flutter/material.dart';
import 'package:foundation/foundation.dart';
import '../models/images.dart';
import '../services/img_crud_service.dart';
import 'dart:typed_data';

class SearchSeedImage extends StatefulWidget {
  const SearchSeedImage({super.key});

  @override
  State<SearchSeedImage> createState() => _SearchSeedImageState();
}

class _SearchSeedImageState extends State<SearchSeedImage> {
  final TextEditingController _searchController = TextEditingController();
  final _imgCrudService = ImgCrudService();
  final Map<String, Future<Uint8List>> _imageFutures = {};
  List<Img> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final loadedImages = await _imgCrudService.getImagesByType('f51c8a56-bdf6-46c5-b53a-0c53ae82310c');

    if (!mounted) return;
    setState(() {
      _images = loadedImages;
    });
  }

  Future<Uint8List> _getImage(String storagePath) {
    return _imageFutures.putIfAbsent(storagePath, () => _imgCrudService.getImage(storagePath));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext pageContext) {
    final searchText = _searchController.text.toLowerCase();

    final filteredImages = _images.where((image) {
      return image.searchTerms.toLowerCase().contains(searchText);
    }).toList();

    return ElnoSelectionLayout(
      pageTitle: 'Search for an image',

      searchField: Padding(
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
                controller: _searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  hintText: 'Find a seed image...',
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

      itemCount: filteredImages.length,

      itemBuilder: (context, index) {
        final image = filteredImages[index];

        return InkWell(
          onTap: () {
            Navigator.pop(pageContext, image);
          },
          child: SizedBox(
            height: 130,
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: FutureBuilder(
                    key: ValueKey(image.imageObjectUuid),
                    future: _getImage(image.storagePath),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      }

                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      return Image.memory(snapshot.data!, fit: BoxFit.contain);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(child: Text(image.searchTerms)),
              ],
            ),
          ),
        );
      },
    );
  }
}
