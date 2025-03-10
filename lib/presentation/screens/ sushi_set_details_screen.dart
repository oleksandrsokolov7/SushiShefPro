import 'package:flutter/material.dart';
import 'recipe_image_screen.dart';

class SushiSetDetailsScreen extends StatelessWidget {
  final String setName;
  final List<String> rolls;

  const SushiSetDetailsScreen(
    param0, {
    super.key,
    required this.setName,
    required this.rolls,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(setName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: rolls.length,
          itemBuilder: (context, index) {
            final roll = rolls[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(roll.split('.').first), // Отображаем имя ролла
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeImageScreen(
                        imagePath: 'assets/images/$roll',
                        fullScreen: true,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
