import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pidkazki2/AuthenticationService.dart';
import 'package:pidkazki2/create_sushi_set_screen.dart';
import 'package:pidkazki2/RecipeSearchScreen.dart';
import 'package:pidkazki2/SavedSushiSetsScreen.dart';
import 'package:pidkazki2/SignInScreen.dart'; // Импортируем экран входа
// Импортируем сервис аутентификации

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthenticationService _authService =
      AuthenticationService(); // Экземпляр AuthenticationService

  // Логика выхода из аккаунта
  void _logout(BuildContext context) async {
    await _authService
        .signOut(); // Вызов метода signOut из AuthenticationService
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => const SignInScreen()), // Переход на экран входа
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Суші Рецепти'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context), // Вызов метода выхода
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RecipeSearchScreen()),
                );
              },
              child: const Text('Роли'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateSushiSetScreen(
                      availableRolls: [],
                    ),
                  ),
                );
              },
              child: const Text('Создать сет'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SavedSushiSetsScreen()),
                );
              },
              child: const Text('Сеты'),
            ),
          ],
        ),
      ),
    );
  }
}
