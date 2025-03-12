import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});

  @override
  _SetPinScreenState createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  final TextEditingController _pinController = TextEditingController();

  Future<void> _savePin() async {
    if (_pinController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_pin', _pinController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN-код успішно збережено!')),
      );
      Navigator.pop(context); // Повернення назад після успішного збереження
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введіть PIN-код!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Встановіть PIN-код')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'Введіть новий PIN-код',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true, // Приховує символи
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePin,
              child: const Text('Зберегти PIN-код'),
            ),
          ],
        ),
      ),
    );
  }
}
