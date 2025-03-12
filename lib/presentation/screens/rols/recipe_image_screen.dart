import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Для управления ориентацией
import 'package:wakelock_plus/wakelock_plus.dart';

class RecipeImageScreen extends StatefulWidget {
  final String imagePath;
  final bool fullScreen;

  const RecipeImageScreen({
    super.key,
    required this.imagePath,
    this.fullScreen = false,
  });

  @override
  State<RecipeImageScreen> createState() => _RecipeImageScreenState();
}

class _RecipeImageScreenState extends State<RecipeImageScreen> {
  @override
  void initState() {
    super.initState();
    // Устанавливаем альбомную ориентацию
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Включаем Wakelock
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Возвращаем ориентацию экрана в портретный режим
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // Отключаем Wakelock
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fullScreen ? null : AppBar(title: const Text('Рецепт')),
      body: GestureDetector(
        onTap: () {
          if (widget.fullScreen) Navigator.pop(context);
        },
        child: Center(
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
