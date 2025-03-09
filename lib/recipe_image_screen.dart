import 'package:flutter/material.dart';

class RecipeImageScreen extends StatelessWidget {
  final String imagePath;
  final bool fullScreen;

  const RecipeImageScreen({
    required this.imagePath,
    required this.fullScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: InteractiveViewer(
                child: Image.asset(imagePath),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 193, 21, 21), size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
