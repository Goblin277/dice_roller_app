import 'package:flutter/material.dart';
import 'models/dice.dart';
import 'screens/color_picker_screen.dart';

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
  late Dice _dice;
  Color _diceColor = Colors.amber;

  @override
  void initState() {
    super.initState();
    _dice = Dice(sides: _selectedSides);
    _rollDice();
  }

  void _rollDice() {
    setState(() {
      _currentResult = _dice.roll();
    });
  }

  void _changeSides(int newSides) {
    setState(() {
      _selectedSides = newSides;
      _dice = Dice(sides: _selectedSides);
    });
    _rollDice();
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
                color: _diceColor,
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

            _buildSidesSelector(),
            const SizedBox(height: 30),

            OutlinedButton.icon(
              onPressed: _openColorPicker,
              icon: const Icon(Icons.color_lens),
              label: const Text('Изменить цвет кости'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidesSelector() {
    return Column(
      children: [
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
            _changeSides(newSelection.first);
          },
        ),
      ],
    );
  }

  void _openColorPicker() async {
    final Color? selectedColor = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColorPickerScreen()),
    );
    if (selectedColor != null) {
      setState(() {
        _diceColor = selectedColor;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Цвет изменён на ${_getColorName(selectedColor)}')),
      );
    }
  }

  String _getColorName(Color color) {
    if (color == Colors.amber) return 'жёлтый';
    if (color == Colors.red) return 'красный';
    if (color == Colors.blue) return 'синий';
    if (color == Colors.green) return 'зелёный';
    if (color == Colors.purple) return 'фиолетовый';
    if (color == Colors.pink) return 'розовый';
    if (color == Colors.orange) return 'оранжевый';
    if (color == Colors.teal) return 'бирюзовый';
    return 'выбран';
  }
}