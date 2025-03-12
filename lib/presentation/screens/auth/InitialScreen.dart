import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sushi_shef_asistant/presentation/screens/auth/sign_in_screen.dart';
import 'package:sushi_shef_asistant/presentation/screens/home_screen.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Отримуємо поточного користувача
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Якщо користувач авторизований, перенаправляємо на HomeScreen
      return const HomeScreen();
    } else {
      // Якщо користувач не авторизований, перенаправляємо на SignInScreen
      return const SignInScreen();
    }
  }
}
