import 'package:flutter/material.dart';
import 'package:pidkazki2/recipe_image_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewSushiSetScreen extends StatefulWidget {
  final String setName;
  final List<String> rolls;

  const ViewSushiSetScreen({
    super.key,
    required this.setName,
    required this.rolls,
  });

  @override
  _ViewSushiSetScreenState createState() => _ViewSushiSetScreenState();
}

class _ViewSushiSetScreenState extends State<ViewSushiSetScreen> {
  late String _setName;
  late List<String> _rolls;

  @override
  void initState() {
    super.initState();
    _setName = widget.setName;
    _rolls = List.from(widget.rolls);
  }

  Future<void> _saveUpdatedSet() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentSets = prefs.getStringList('savedSets') ?? [];

    // Удаляем старое имя сета, если оно изменилось
    currentSets.removeWhere((set) => set.startsWith('${widget.setName}|'));

    // Сохраняем новый сет
    final updatedSetData = '$_setName|${_rolls.join('|')}';
    currentSets.add(updatedSetData);
    await prefs.setStringList('savedSets', currentSets);
  }

  void _openRoll(String roll) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeImageScreen(
          imagePath: 'assets/images/$roll',
          fullScreen: true,
        ),
      ),
    );
  }

  void _deleteRoll(String roll) {
    setState(() {
      _rolls.remove(roll);
    });
    _saveUpdatedSet();
  }

  void _editSetName() async {
    String? newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller =
            TextEditingController(text: _setName);
        return AlertDialog(
          title: const Text('Изменить имя сета'),
          content: TextField(
            controller: controller,
            decoration:
                const InputDecoration(hintText: 'Введите новое имя сета'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        _setName = newName;
      });
      _saveUpdatedSet();
    }
  }

  void _deleteSet() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> currentSets = prefs.getStringList('savedSets') ?? [];
    currentSets.removeWhere((set) => set.startsWith('${widget.setName}|'));
    await prefs.setStringList('savedSets', currentSets);
    Navigator.pop(context); // Возвращаемся на предыдущий экран
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_setName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editSetName,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSet,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Состав сета:'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _rolls.length,
                itemBuilder: (context, index) {
                  String roll = _rolls[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(roll.split('.').first),
                      onTap: () => _openRoll(roll),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRoll(roll),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
