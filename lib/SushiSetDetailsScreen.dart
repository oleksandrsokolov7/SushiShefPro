import 'package:flutter/material.dart';
import 'package:pidkazki2/ViewSushiSetScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedSushiSetsScreen extends StatefulWidget {
  const SavedSushiSetsScreen({super.key});

  @override
  _SavedSushiSetsScreenState createState() => _SavedSushiSetsScreenState();
}

class _SavedSushiSetsScreenState extends State<SavedSushiSetsScreen> {
  List<String> _savedSets = [];
  List<String> _filteredSets = [];
  final TextEditingController _searchController = TextEditingController();

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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedSets = prefs.getStringList('savedSets') ?? [];
      _filteredSets = List.from(_savedSets);
    });
  }

  void _searchSets() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSets = _savedSets.where((set) {
        final setName = set.split('|').first.toLowerCase();
        return setName.contains(query);
      }).toList();
    });
  }

  Future<void> _deleteSet(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String setName = _savedSets[index].split('|').first;
    _savedSets.removeAt(index);
    await prefs.setStringList('savedSets', _savedSets);
    setState(() {
      _filteredSets = List.from(_savedSets);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$setName удалён')),
    );
  }

  void _viewSetDetails(String setData) {
    final setName = setData.split('|').first;
    final rolls = setData.split('|').sublist(1);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewSushiSetScreen(setName: setName, rolls: rolls),
      ),
    );
  }

  Future<void> _editSetName(int index) async {
    String oldSetData = _savedSets[index];
    String oldName = oldSetData.split('|').first;
    List<String> rolls = oldSetData.split('|').sublist(1);

    TextEditingController controller = TextEditingController(text: oldName);

    String? newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать название'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Новое название'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty && newName != oldName) {
      String newSetData = [newName, ...rolls].join('|');
      setState(() {
        _savedSets[index] = newSetData;
        _filteredSets = List.from(_savedSets);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('savedSets', _savedSets);
    }
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
          Expanded(
            child: _filteredSets.isEmpty
                ? const Center(child: Text('Нет сохранённых сетов'))
                : ListView.builder(
                    itemCount: _filteredSets.length,
                    itemBuilder: (context, index) {
                      final setData = _filteredSets[index];
                      final setName = setData.split('|').first;

                      return Dismissible(
                        key: Key(setData),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteSet(index);
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
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editSetName(index),
                            ),
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
