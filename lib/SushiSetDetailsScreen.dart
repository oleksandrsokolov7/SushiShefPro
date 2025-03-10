import 'package:flutter/material.dart';
import 'package:pidkazki2/recipe_image_screen.dart';

class SushiSetDetailsScreen extends StatelessWidget {
  final String setName;
  final List<String> rolls;

  const SushiSetDetailsScreen(
      {super.key, required this.setName, required this.rolls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(setName)),
      body: ListView.builder(
        itemCount: rolls.length,
        itemBuilder: (context, index) {
          final roll = rolls[index];
          return ListTile(
            title: Text(roll.split('.').first),
            onTap: () {
              // Переход на экран с изображением ролла
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeImageScreen(
                      imagePath: 'assets/images/$roll', fullScreen: true),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
