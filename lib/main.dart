import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pidkazki2/core/services/authentication_service.dart';
import 'package:pidkazki2/firebase_options.dart';
import 'package:pidkazki2/presentation/screens/create_sushi_set_screen.dart';
import 'package:pidkazki2/presentation/screens/home_screen.dart';
import 'package:pidkazki2/presentation/screens/recipe_search_screen.dart';
import 'package:pidkazki2/presentation/screens/saved_sushi_sets_screen.dart';
import 'package:pidkazki2/presentation/screens/sign_in_screen.dart';
import 'core/constants/app_constants.dart';

import 'presentation/blocs/auth_bloc.dart';

void main() async {
  // Ensure Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(AuthenticationService())..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return HomeScreen();
                  } else {
                    return SignInScreen();
                  }
                },
              ),
          '/signIn': (context) => SignInScreen(),
          '/home': (context) => const HomeScreen(),
          '/createSushiSet': (context) => CreateSushiSetScreen(
                availableRolls: [], // Пустой список для примера
              ),
          '/savedSushiSets': (context) => SavedSushiSetsScreen(),
          '/recipeSearch': (context) => RecipeSearchScreen(),
        },
      ),
    );
  }
}
