import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SetRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSet(String setName, List<String> rolls) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print("Ошибка: пользователь не авторизован");
        return;
      }

      // Сохраняем локально, если нет сети
      await _saveSetLocally(setName, rolls, userId);

      // Пробуем отправить в Firebase
      await _saveSetToFirebase(setName, rolls, userId);
    } catch (e) {
      print('Ошибка при сохранении сета: $e');
    }
  }

  Future<void> _saveSetToFirebase(
      String setName, List<String> rolls, String userId) async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('Ошибка: Пользователь не авторизован');
        return;
      }

      await FirebaseFirestore.instance.collection('sets').add({
        'setName': setName,
        'owner': userId,
        'rolls': rolls,
        'createdAt': Timestamp.now(),
      });

      print('Сет успешно сохранён в Firebase');
    } catch (e) {
      print('Ошибка при сохранении сета в Firebase: $e');
    }
  }

  Future<void> _saveSetLocally(
      String setName, List<String> rolls, String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> localSets = prefs.getStringList('local_sets') ?? [];

      Map<String, dynamic> newSet = {
        'setName': setName,
        'owner': userId,
        'rolls': rolls,
        'createdAt': DateTime.now().toIso8601String(),
      };

      localSets.add(jsonEncode(newSet));
      await prefs.setStringList('local_sets', localSets);
    } catch (e) {
      print('Ошибка при локальном сохранении сета: $e');
    }
  }

  Future<void> syncLocalSetsWithFirebase() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> localSets = prefs.getStringList('local_sets') ?? [];
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    for (String setJson in localSets) {
      Map<String, dynamic> set = jsonDecode(setJson);
      await _saveSetToFirebase(
          set['setName'], List<String>.from(set['rolls']), userId);
    }

    await prefs.remove('local_sets'); // Очищаем локальные данные после загрузки
  }
}
