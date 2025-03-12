import 'package:flutter/material.dart';
import 'package:sushi_shef_asistant/presentation/screens/auth/InitialScreen.dart';

import 'package:sushi_shef_asistant/presentation/screens/auth/sign_in_screen.dart';
import 'package:sushi_shef_asistant/presentation/screens/home_screen.dart';
import 'package:sushi_shef_asistant/presentation/screens/sets/create_sushi_set_screen.dart';
import 'package:sushi_shef_asistant/presentation/screens/sets/saved_sushi_sets_screen.dart';
import 'package:sushi_shef_asistant/presentation/screens/rols/recipe_search_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getAllRoutes(BuildContext context) {
    return {
      '/': (_) => const InitialScreen(), // Новий маршрут для перевірки
      '/signIn': (_) => const SignInScreen(),

      '/createSushiSet': (_) => const CreateSushiSetScreen(availableRolls: []),
      '/savedSushiSets': (_) => const SavedSushiSetsScreen(),
      '/recipeSearch': (_) => const RecipeSearchScreen(),
      '/clientDashboard': (_) => const HomeScreen(),
      '/chefDashboard': (_) => const HomeScreen(), // Доданий маршрут
    };
  }
}
