import 'package:flutter/material.dart';

class SushiCardWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SushiCardWidget({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
