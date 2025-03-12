import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sushi_shef_asistant/core/constants/firebase_options.dart';
import 'package:sushi_shef_asistant/core/services/authentication_service.dart';

import 'package:sushi_shef_asistant/presentation/blocs/auth_bloc.dart';
import 'package:sushi_shef_asistant/core/constants/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (_) =>
                  AuthBloc(AuthenticationService())..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Sushi Chef Assistant',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: AppRoutes.getAllRoutes(context),
      ),
    );
  }
}
