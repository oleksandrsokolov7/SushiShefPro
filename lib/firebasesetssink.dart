import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveSet(String setName, List<String> rolls) async {
  final prefs = await SharedPreferences.getInstance();
  final String setData = '$setName|${rolls.join('|')}';

  List<String> currentSets = prefs.getStringList('savedSets') ?? [];
  currentSets.add(setData);
  await prefs.setStringList('savedSets', currentSets);

  // Попытка сохранения в Firebase
  _saveSetToFirebase(setName, rolls);
}

Future<void> _saveSetToFirebase(String setName, List<String> rolls) async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";

    await FirebaseFirestore.instance.collection('sets').add({
      'setName': setName,
      'owner': userId,
      'rolls': rolls,
      'createdAt': Timestamp.now(),
    });
  } catch (e) {
    print('Ошибка при сохранении сета в Firebase: $e');
  }
}

Future<void> syncLocalSetsWithFirebase() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> localSets = prefs.getStringList('savedSets') ?? [];

  for (String setData in localSets) {
    List<String> parts = setData.split('|');
    if (parts.length > 1) {
      String setName = parts[0];
      List<String> rolls = parts.sublist(1);
      await _saveSetToFirebase(setName, rolls);
    }
  }

  await prefs
      .remove('savedSets'); // Очищаем локальный список после синхронизации
}

Future<List<Map<String, dynamic>>> loadSetsFromFirebase(
    bool showOwnSets) async {
  try {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "unknown_user";
    QuerySnapshot snapshot;

    if (showOwnSets) {
      snapshot = await FirebaseFirestore.instance
          .collection('sets')
          .where('owner', isEqualTo: userId)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance.collection('sets').get();
    }

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Ошибка при загрузке данных из Firebase: $e');
    return [];
  }
}
