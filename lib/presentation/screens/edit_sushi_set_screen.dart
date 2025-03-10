import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditSushiSetScreen extends StatefulWidget {
  final String setId;
  final String initialSetName;
  final List<String> initialRolls;

  const EditSushiSetScreen({
    super.key,
    required this.setId,
    required this.initialSetName,
    required this.initialRolls,
  });

  @override
  _EditSushiSetScreenState createState() => _EditSushiSetScreenState();
}

class _EditSushiSetScreenState extends State<EditSushiSetScreen> {
  final TextEditingController _setNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<String> _availableRolls = [];
  List<String> _selectedRolls = [];
  List<String> _matches = [];

  @override
  void initState() {
    super.initState();
    _setNameController.text = widget.initialSetName;
    _selectedRolls = List.from(widget.initialRolls);
    _loadImageList();
  }

  Future<void> _loadImageList() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      setState(() {
        _availableRolls = manifestMap.keys
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
      _matches = _availableRolls
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

  Future<void> _updateSet() async {
    if (_setNameController.text.isEmpty || _selectedRolls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название и выберите роллы!')),
      );
      return;
    }

    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";

      await FirebaseFirestore.instance
          .collection('sets')
          .doc(widget.setId)
          .update({
        'setName': _setNameController.text,
        'rolls': _selectedRolls,
        'owner': userId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Сет обновлён!')),
      );

      Navigator.pop(
          context, true); // Вернём true, чтобы обновить экран сохранённых сетов
    } catch (e) {
      print('Ошибка при обновлении сета: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка при обновлении!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Редактировать сет')),
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
            const Text('Выбранные роллы:'),
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
              onPressed: _updateSet,
              child: const Text('Сохранить изменения'),
            ),
          ],
        ),
      ),
    );
  }
}
