import 'package:flutter/material.dart';
import 'recipe_search_screen.dart';
import 'create_sushi_set_screen.dart';
import 'saved_sushi_sets_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Суши Рецепты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              // Выход из аккаунта (вызов события SignOutRequested)
              Navigator.pushReplacementNamed(context, '/signIn');
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
                    builder: (context) => CreateSushiSetScreen(
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
