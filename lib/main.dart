import 'package:flutter/material.dart';

void main() {
  runApp(const DiceRollerApp());
}

class DiceRollerApp extends StatelessWidget {
  const DiceRollerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Roller',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DiceRollerScreen(),
    );
  }
}

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({super.key});

  @override
  State<DiceRollerScreen> createState() => _DiceRollerScreenState();
}

class _DiceRollerScreenState extends State<DiceRollerScreen> {
  int _currentResult = 1;
  int _selectedSides = 6;

  void _rollDice() {
    setState(() {
      _currentResult = _generateRandomNumber();
    });
  }

  int _generateRandomNumber() {
    return (DateTime.now().millisecondsSinceEpoch % _selectedSides) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кости'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(blurRadius: 10, offset: Offset(5, 5)),
                ],
              ),
              child: Center(
                child: Text(
                  '$_currentResult',
                  style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Кнопка броска
            ElevatedButton.icon(
              onPressed: _rollDice,
              icon: const Icon(Icons.casino),
              label: const Text('Бросить!'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                textStyle: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              'Количество граней:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 4, label: Text('d4')),
                ButtonSegment(value: 6, label: Text('d6')),
                ButtonSegment(value: 8, label: Text('d8')),
                ButtonSegment(value: 10, label: Text('d10')),
                ButtonSegment(value: 12, label: Text('d12')),
                ButtonSegment(value: 20, label: Text('d20')),
              ],
              selected: {_selectedSides},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _selectedSides = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 30),

            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Выбор цвета будет добавлен позже')),
                );
              },
              icon: const Icon(Icons.color_lens),
              label: const Text('Изменить цвет кости'),
            ),
          ],
        ),
      ),
    );
  }
}