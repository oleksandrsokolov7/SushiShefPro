import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pidkazki2/recipe_image_screen.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _availableImages = [];
  List<String> _matches = [];

  @override
  void initState() {
    super.initState();
    _loadImageList();
  }

  Future<void> _loadImageList() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      setState(() {
        _availableImages = manifestMap.keys
            .where((String key) => key.startsWith('assets/images/'))
            .map((String key) => key.split('/').last)
            .toList();
        _matches = List.from(_availableImages);
      });
    } catch (e) {
      print('Ошибка загрузки списка изображений: $e');
    }
  }

  void _searchRecipe(String query) {
    setState(() {
      _matches = _availableImages
          .where((image) => image.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _openRecipe(String image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeImageScreen(
          imagePath: 'assets/images/$image',
          fullScreen: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Роли')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Пошук',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchRecipe,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  String displayName = _matches[index].split('.').first;
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(displayName),
                      onTap: () => _openRecipe(_matches[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
