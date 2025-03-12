import 'package:flutter/material.dart';
import 'package:sushi_shef_asistant/presentation/screens/auth/cheff/chef_pin_screen.dart';
import 'package:sushi_shef_asistant/presentation/screens/auth/clien/client_info_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор роли')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChefPinScreen(),
                  ),
                );
              },
              child: const Text('Повар'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClientInfoScreen(),
                  ),
                );
              },
              child: const Text('Клиент'),
            ),
          ],
        ),
      ),
    );
  }
}
