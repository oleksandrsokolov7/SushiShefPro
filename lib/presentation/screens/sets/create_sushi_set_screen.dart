import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_shef_asistant/presentation/screens/sets/view_sushi_set_screen.dart';
import 'package:sushi_shef_asistant/core/services/firebase_service.dart';

class CreateSushiSetScreen extends StatefulWidget {
  const CreateSushiSetScreen({super.key, required List availableRolls});

  @override
  _CreateSushiSetScreenState createState() => _CreateSushiSetScreenState();
}

class _CreateSushiSetScreenState extends State<CreateSushiSetScreen> {
  List<String> _availableRolls = [];
  final List<String> _selectedRolls = [];
  final TextEditingController _setNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
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
        _availableRolls =
            manifestMap.keys
                .where((String key) => key.startsWith('assets/images/'))
                .map((String key) => key.split('/').last)
                .toList();
        _matches = List.from(_availableRolls);
      });
    } catch (e) {
      print('Ошибка загрузки списка изображений: $e');
    }
  }

  void _searchRolls(String query) {
    setState(() {
      _matches =
          _availableRolls
              .where((roll) => roll.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _toggleRollSelection(String roll) {
    setState(() {
      if (_selectedRolls.contains(roll)) {
        _selectedRolls.remove(roll);
      } else {
        _selectedRolls.add(roll);
      }
    });
  }

  void _createSet() async {
    if (_setNameController.text.isNotEmpty && _selectedRolls.isNotEmpty) {
      await saveSet(_setNameController.text, _selectedRolls);
      // Уведомление об успешном создании
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Сет успешно создан!')));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ViewSushiSetScreen(
                setName: _setNameController.text,
                rolls: _selectedRolls,
              ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Ошибка'),
              content: const Text(
                'Пожалуйста, введите название сета и выберите хотя бы один ролл.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создать сет')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _setNameController,
              decoration: const InputDecoration(
                labelText: 'Название сета',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск роллов',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchRolls,
            ),
            const SizedBox(height: 20),
            const Text('Выберите роллы для сета:'),
            Expanded(
              child: ListView.builder(
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  final roll = _matches[index];
                  return ListTile(
                    title: Text(roll.split('.').first),
                    trailing: Checkbox(
                      value: _selectedRolls.contains(roll),
                      onChanged: (bool? value) {
                        _toggleRollSelection(roll);
                      },
                    ),
                    onTap: () {
                      _toggleRollSelection(roll);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createSet,
              child: const Text('Создать сет'),
            ),
          ],
        ),
      ),
    );
  }
}
