import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Сохранение сета локально и в Firebase
Future<void> saveSet(String setName, List<String> rolls) async {
  final prefs = await SharedPreferences.getInstance();
  final String setData = '$setName|${rolls.join('|')}';

  List<String> currentSets = prefs.getStringList('savedSets') ?? [];
  currentSets.add(setData);
  await prefs.setStringList('savedSets', currentSets);

  // Сохраняем в Firebase
  await saveSetToFirebase(setName, rolls);
}

// Сохранение сета в Firebase
Future<void> saveSetToFirebase(String setName, List<String> rolls) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Ошибка: пользователь не авторизован');
      return;
    }

    print('Сохранение сета в Firebase: $setName, ${rolls.join(', ')}');

    await FirebaseFirestore.instance.collection('sets').add({
      'setName': setName,
      'owner': user.uid,
      'rolls': rolls,
      'createdAt': Timestamp.now(),
    });

    print('✅ Сет успешно сохранен в Firebase');
  } catch (e) {
    print('❌ Ошибка при сохранении сета в Firebase: $e');
  }
}

// Загрузка сетов из Firebase (фильтрация по владельцу)
Future<List<Map<String, dynamic>>> loadSetsFromFirebase(
    bool showOwnSets) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('Ошибка: пользователь не авторизован');
      return [];
    }

    QuerySnapshot snapshot;
    if (showOwnSets) {
      snapshot = await FirebaseFirestore.instance
          .collection('sets')
          .where('owner', isEqualTo: user.uid)
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance.collection('sets').get();
    }

    print('✅ Загружено ${snapshot.docs.length} сетов из Firebase');

    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Добавляем ID документа
      return data;
    }).toList();
  } catch (e) {
    print('❌ Ошибка при загрузке сетов из Firebase: $e');
    return [];
  }
}

// Синхронизация локальных сетов с Firebase
Future<void> syncLocalSetsWithFirebase() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> localSets = prefs.getStringList('savedSets') ?? [];

  for (String setData in localSets) {
    List<String> parts = setData.split('|');
    if (parts.length < 2) continue;
    String setName = parts[0];
    List<String> rolls = parts.sublist(1);

    await saveSetToFirebase(setName, rolls);
  }

  // Очистка локального хранилища после синхронизации
  await prefs.remove('savedSets');
  print('✅ Локальные сеты синхронизированы с Firebase');
}

// Удаление сета из Firebase
Future<void> deleteSetFromFirebase(String setId) async {
  try {
    await FirebaseFirestore.instance.collection('sets').doc(setId).delete();
    print('✅ Сет $setId удален из Firebase');
  } catch (e) {
    print('❌ Ошибка при удалении сета из Firebase: $e');
  }
}
