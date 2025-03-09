import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pidkazki2/CreateSushiSetScreen.dart';
import 'package:pidkazki2/RecipeSearchScreen.dart';
import 'package:pidkazki2/SignInScreen.dart';
import 'package:pidkazki2/firebase_options.dart';
import 'package:pidkazki2/SavedSushiSetsScreen.dart';

void main() async {
  // Ensure Firebase is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sushi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(), // Стартуем с экрана входа
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

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

// class RecipeSearchScreen extends StatefulWidget {
//   const RecipeSearchScreen({super.key});

//   @override
//   _RecipeSearchScreenState createState() => _RecipeSearchScreenState();
// }

// class _RecipeSearchScreenState extends State<RecipeSearchScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> _availableImages = [];
//   List<String> _matches = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadImageList();
//     WakelockPlus.enable();
//   }

//   @override
//   void dispose() {
//     WakelockPlus.disable();
//     super.dispose();
//   }

//   Future<void> _loadImageList() async {
//     try {
//       final manifestContent = await rootBundle.loadString('AssetManifest.json');
//       final Map<String, dynamic> manifestMap = json.decode(manifestContent);

//       setState(() {
//         _availableImages = manifestMap.keys
//             .where((String key) => key.startsWith('assets/images/'))
//             .map((String key) => key.split('/').last)
//             .toList();
//         _matches = List.from(_availableImages);
//       });
//     } catch (e) {
//       print('Помилка завантаження списку зображень: $e');
//     }
//   }

//   void _searchRecipe(String query) {
//     setState(() {
//       _matches = _availableImages
//           .where((image) => image.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _openRecipe(String image) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RecipeImageScreen(
//           imagePath: 'assets/images/$image',
//           fullScreen: true,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Роли')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 labelText: 'Пошук',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: _searchRecipe,
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _matches.length,
//                 itemBuilder: (context, index) {
//                   String displayName = _matches[index].split('.').first;
//                   return Card(
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: ListTile(
//                       title: Text(displayName),
//                       onTap: () => _openRecipe(_matches[index]),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
