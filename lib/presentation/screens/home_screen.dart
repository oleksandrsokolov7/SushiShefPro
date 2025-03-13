import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sushi_shef_asistant/presentation/screens/rols/recipe_search_screen.dart';
import 'sets/create_sushi_set_screen.dart';
import 'sets/saved_sushi_sets_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> signOutAndRedirect(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Вихід з облікового запису
      Navigator.pushReplacementNamed(
        context,
        '/signIn',
      ); // Перехід на екран входу
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Помилка виходу: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Суши Рецепты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              signOutAndRedirect(context); // Виклик функції виходу
            },
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
                  MaterialPageRoute(builder: (context) => RecipeSearchScreen()),
                );
              },
              child: const Text('Ролы'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CreateSushiSetScreen(availableRolls: []),
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
                    builder: (context) => const SavedSushiSetsScreen(),
                  ),
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
