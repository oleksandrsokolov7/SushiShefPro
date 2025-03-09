import 'package:flutter/material.dart';
import 'package:pidkazki2/ViewSushiSetScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedSushiSetsScreen extends StatefulWidget {
  const SavedSushiSetsScreen({super.key});

  @override
  _SavedSushiSetsScreenState createState() => _SavedSushiSetsScreenState();
}

class _SavedSushiSetsScreenState extends State<SavedSushiSetsScreen> {
  List<Map<String, dynamic>> _savedSets = [];
  List<Map<String, dynamic>> _filteredSets = [];
  final TextEditingController _searchController = TextEditingController();
  bool _showMySets = true; // Флаг для отображения "моих" сетов

  @override
  void initState() {
    super.initState();
    _loadSavedSets();
    _searchController.addListener(_searchSets);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchSets);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return; // Если пользователь не авторизован, не загружаем данные
    }

    final userId = user.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('sets')
        .get();

    setState(() {
      _savedSets = querySnapshot.docs.map((doc) {
        return {
          'setName': doc['name'],
          'ownerId': doc['ownerId'],
          'setId': doc.id,
          'rolls': List<String>.from(doc['rolls']),
        };
      }).toList();

      // Фильтрация по владельцу: отображать только "мои" или все сеты
      _filteredSets = _savedSets.where((set) {
        if (_showMySets) {
          return set['ownerId'] == userId;
        }
        return true; // Показывать все сеты, если фильтр не включен
      }).toList();
    });
  }

  void _searchSets() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSets = _savedSets.where((set) {
        final setName = set['setName'].toLowerCase();
        return setName.contains(query);
      }).toList();
    });
  }

  Future<void> _deleteSet(String setId) async {
    await FirebaseFirestore.instance.collection('sets').doc(setId).delete();

    setState(() {
      _savedSets.removeWhere((set) => set['setId'] == setId);
      _filteredSets = List.from(_savedSets);
    });
  }

  void _viewSetDetails(Map<String, dynamic> setData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewSushiSetScreen(
          setName: setData['setName'],
          rolls: setData['rolls'],
        ),
      ),
    );
  }

  void _toggleSetFilter(bool value) {
    setState(() {
      _showMySets = value;
      _loadSavedSets(); // Перезагрузить сеты после смены фильтра
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сохранённые сеты')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Поиск сета',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            children: [
              Text('Мои сеты'),
              Switch(
                value: _showMySets,
                onChanged: _toggleSetFilter,
              ),
            ],
          ),
          Expanded(
            child: _filteredSets.isEmpty
                ? const Center(child: Text('Нет сохранённых сетов'))
                : ListView.builder(
                    itemCount: _filteredSets.length,
                    itemBuilder: (context, index) {
                      final setData = _filteredSets[index];
                      final setName = setData['setName'];

                      return Dismissible(
                        key: Key(setData['setId']),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteSet(setData['setId']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$setName удалён')),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(setName),
                            onTap: () => _viewSetDetails(setData),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
