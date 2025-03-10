import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pidkazki2/ViewSushiSetScreen.dart';
import 'package:pidkazki2/firebasesetssink.dart';

class SavedSetsScreen extends StatefulWidget {
  const SavedSetsScreen({super.key});

  @override
  _SavedSetsScreenState createState() => _SavedSetsScreenState();
}

class _SavedSetsScreenState extends State<SavedSetsScreen> {
  bool _showOwnSets = true;
  List<Map<String, dynamic>> _savedSets = [];

  @override
  void initState() {
    super.initState();
    _loadSavedSets();
  }

  Future<void> _loadSavedSets() async {
    List<Map<String, dynamic>> sets = await loadSetsFromFirebase(_showOwnSets);
    setState(() {
      _savedSets = sets;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сохранённые сеты')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Показывать только свои сеты'),
            value: _showOwnSets,
            onChanged: (value) {
              setState(() {
                _showOwnSets = value;
                _loadSavedSets();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _savedSets.length,
              itemBuilder: (context, index) {
                final set = _savedSets[index];
                return ListTile(
                  title: Text(set['setName']),
                  subtitle: Text('Состав: ${set['rolls'].join(', ')}'),
                  onTap: () {
                    // Открыть подробности сета
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewSushiSetScreen(
                          setName: set['setName'],
                          rolls: List<String>.from(set['rolls']),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
