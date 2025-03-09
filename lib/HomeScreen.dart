import 'package:flutter/material.dart';
import 'package:pidkazki2/CreateSushiSetScreen.dart';
import 'package:pidkazki2/RecipeSearchScreen.dart';
import 'package:pidkazki2/SavedSushiSetsScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Суші Рецепти')),
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
                          )),
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
                      builder: (context) => SavedSushiSetsScreen()),
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
