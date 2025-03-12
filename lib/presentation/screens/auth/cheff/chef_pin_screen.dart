import 'package:flutter/material.dart';

class ChefPinScreen extends StatefulWidget {
  const ChefPinScreen({super.key});

  @override
  _ChefPinScreenState createState() => _ChefPinScreenState();
}

class _ChefPinScreenState extends State<ChefPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _correctPin = "1234"; // Встановлений PIN-код для перевірки

  void _verifyPin() {
    if (_pinController.text == _correctPin) {
      // Успішна верифікація
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Доступ надано!')));
      Navigator.pushReplacementNamed(
        context,
        '/chefDashboard',
      ); // Переход на наступний екран
    } else {
      // Помилка верифікації
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Невірний PIN-код!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Введіть PIN-код')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              decoration: const InputDecoration(
                labelText: 'PIN-код',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Пароль прихований під час вводу
              keyboardType: TextInputType.number, // Тільки цифри
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyPin,
              child: const Text('Підтвердити'),
            ),
          ],
        ),
      ),
    );
  }
}
