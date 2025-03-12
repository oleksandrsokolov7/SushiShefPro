import 'package:flutter/material.dart';

class VerifyPinScreen extends StatefulWidget {
  const VerifyPinScreen({super.key});

  @override
  _VerifyPinScreenState createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final String _correctPin = "777777"; // Жорстко заданий PIN-код

  void _verifyPin() {
    if (_pinController.text == _correctPin) {
      // Успішна верифікація
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Вхід успішний!')));
      Navigator.pushReplacementNamed(
        context,
        '/home',
      ); // Переходимо до головного екрану
    } else {
      // Невірний PIN-код
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
              keyboardType: TextInputType.number,
              obscureText: true,
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
