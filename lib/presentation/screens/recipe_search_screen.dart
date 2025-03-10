import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'recipe_image_screen.dart';

class RecipeSearchScreen extends StatefulWidget {
  const RecipeSearchScreen({super.key});

  @override
  State<RecipeSearchScreen> createState() => _RecipeSearchScreenState();
}

class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _availableRolls = [];
  List<String> _filteredRolls = [];

  @override
  void initState() {
    super.initState();
    _loadRolls();
  }

  // Загружаем список роллов из ресурсов
  Future<void> _loadRolls() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      setState(() {
        _availableRolls = manifestMap.keys
            .where((String key) => key.startsWith('assets/images/'))
            .map((String key) => key.split('/').last)
            .toList();
        _filteredRolls =
            List.from(_availableRolls); // Изначально показываем всё
      });
    } catch (e) {
      print('Ошибка загрузки списка роллов: $e');
    }
  }

  // Фильтрация роллов по запросу
  void _filterRolls(String query) {
    setState(() {
      _filteredRolls = _availableRolls
          .where((roll) => roll.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Переход на экран с изображением рецепта
  void _viewRecipe(String roll) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeImageScreen(
          imagePath: 'assets/images/$roll',
          fullScreen: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ролы')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterRolls,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRolls.length,
                itemBuilder: (context, index) {
                  final roll = _filteredRolls[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(roll.split('.').first),
                      onTap: () => _viewRecipe(roll),
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
