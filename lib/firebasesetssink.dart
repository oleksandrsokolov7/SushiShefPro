import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveSet(String setName, List<String> rolls) async {
  final prefs = await SharedPreferences.getInstance();
  final String setData = '$setName|${rolls.join('|')}';

  List<String> currentSets = prefs.getStringList('savedSets') ?? [];
  currentSets.add(setData);
  await prefs.setStringList('savedSets', currentSets);

  // Сохраняем в Firebase
  await saveSetToFirebase(setName, rolls);
}

Future<void> saveSetToFirebase(String setName, List<String> rolls) async {
  try {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("Ошибка: пользователь не авторизован");
      return;
    }

    await FirebaseFirestore.instance.collection('sets').add({
      'setName': setName,
      'ownerId':
          userId, // Исправлено, чтобы соответствовать `loadSetsFromFirebase`
      'rolls': rolls,
      'createdAt': Timestamp.now(),
    });

    print("Сет успешно сохранён в Firebase");
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
      await saveSetToFirebase(setName, rolls);
    }
  }

  await prefs
      .remove('savedSets'); // Очищаем локальный список после синхронизации
}

Future<List<Map<String, dynamic>>> loadSetsFromFirebase(
    bool showOwnSets) async {
  try {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print("Ошибка: пользователь не авторизован");
      return [];
    }

    QuerySnapshot snapshot;
    if (showOwnSets) {
      snapshot = await FirebaseFirestore.instance
          .collection('sets')
          .where('ownerId', isEqualTo: userId)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance.collection('sets').get();
    }

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['setId'] = doc.id; // Добавляем ID документа
      return data;
    }).toList();
  } catch (e) {
    print('Ошибка при загрузке данных из Firebase: $e');
    return [];
  }
}
