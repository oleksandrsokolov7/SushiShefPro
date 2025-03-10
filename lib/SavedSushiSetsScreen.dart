import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pidkazki2/ViewSushiSetScreen.dart';
import 'package:pidkazki2/edit_sushi_set_screen.dart';

class SavedSushiSetsScreen extends StatefulWidget {
  const SavedSushiSetsScreen({super.key});

  @override
  State<SavedSushiSetsScreen> createState() => _SavedSushiSetsScreenState();
}

class _SavedSushiSetsScreenState extends State<SavedSushiSetsScreen> {
  bool showOwnSets = true;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";

  Future<List<Map<String, dynamic>>> loadSetsFromFirebase() async {
    try {
      QuerySnapshot snapshot;

      if (showOwnSets) {
        snapshot = await FirebaseFirestore.instance
            .collection('sets')
            .where('owner', isEqualTo: userId)
            .get();
      } else {
        snapshot = await FirebaseFirestore.instance.collection('sets').get();
      }

      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'setName': data['setName'] ?? 'Без названия',
          'rolls': List<String>.from(data['rolls'] ?? []),
          'owner': data['owner'] ?? '',
        };
      }).toList();
    } catch (e) {
      print('Ошибка при загрузке сетов: $e');
      return [];
    }
  }

  Future<void> deleteSet(String setId) async {
    await FirebaseFirestore.instance.collection('sets').doc(setId).delete();
    setState(() {}); // Обновляем список
  }

  Future<void> editSet(String setId, String currentName) async {
    TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактировать сет'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Новое название сета'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('sets')
                    .doc(setId)
                    .update({'setName': nameController.text});
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _loadSets() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Сохранённые сеты'),
        actions: [
          Switch(
            value: showOwnSets,
            onChanged: (value) {
              setState(() {
                showOwnSets = value;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: loadSetsFromFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Ошибка загрузки данных.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет доступных сетов.'));
          }

          List<Map<String, dynamic>> sets = snapshot.data!;
          return ListView.builder(
            itemCount: sets.length,
            itemBuilder: (context, index) {
              final set = sets[index];
              bool isOwner = set['owner'] == userId;

              return Card(
                child: ListTile(
                  title: Text(set['setName']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewSushiSetScreen(
                          setName: set['setName'],
                          rolls: set['rolls'],
                        ),
                      ),
                    );
                  },
                  trailing: isOwner
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditSushiSetScreen(
                                      setId: set['id'], // ID сета из Firebase
                                      initialSetName: set['setName'],
                                      initialRolls:
                                          List<String>.from(set['rolls']),
                                    ),
                                  ),
                                ).then((updated) {
                                  if (updated == true) {
                                    _loadSets(); // Перезагружаем список сетов
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteSet(set['id']),
                            ),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
