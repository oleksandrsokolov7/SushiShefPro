import 'package:flutter/material.dart';
import 'recipe_image_screen.dart';

class ViewSushiSetScreen extends StatelessWidget {
  final String setName;
  final List<String> rolls;

  const ViewSushiSetScreen({
    super.key,
    required this.setName,
    required this.rolls,
  });

  void _openRoll(String roll, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeImageScreen(
          imagePath: 'assets/images/$roll',
          fullScreen: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(setName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Состав сета:'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rolls.length,
                itemBuilder: (context, index) {
                  String roll = rolls[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(roll.split('.').first),
                      onTap: () => _openRoll(roll, context),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
