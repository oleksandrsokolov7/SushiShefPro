import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientInfoScreen extends StatefulWidget {
  const ClientInfoScreen({super.key});

  @override
  _ClientInfoScreenState createState() => _ClientInfoScreenState();
}

class _ClientInfoScreenState extends State<ClientInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _saveClientInfo() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isNotEmpty && phone.isNotEmpty) {
      try {
        // Отримання ідентифікатора користувача
        final String userId =
            'user_${DateTime.now().millisecondsSinceEpoch}'; // Генерація унікального ID
        await _firestore.collection('clients').doc(userId).set({
          'name': name,
          'phone': phone,
          'createdAt': FieldValue.serverTimestamp(), // Дата створення
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Дані клієнта збережено!')),
        );
        Navigator.pushReplacementNamed(
          context,
          '/home',
        ); // Переходимо на головний екран
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Помилка збереження: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Будь ласка, заповніть усі поля')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Дані клієнта')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Ім\'я',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Номер телефону',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveClientInfo,
              child: const Text('Зберегти'),
            ),
          ],
        ),
      ),
    );
  }
}
