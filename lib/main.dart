import 'package:flutter/material.dart';
import 'models/dice.dart';
import 'screens/color_picker_screen.dart';
import 'services/storage_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      debugShowCheckedModeBanner: false,
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
  bool _isRolling = false;
  bool _isLoading = true;

  final List<int> _availableSides = [4, 6, 8, 10, 12, 20];

  final Map<int, _TextConfig> _textConfigs = {
    4:  const _TextConfig(offsetX: 0, offsetY: 0, fontSize: 48),
    6:  const _TextConfig(offsetX: -2, offsetY: -30, fontSize: 48),
    8:  const _TextConfig(offsetX: 0, offsetY: 0, fontSize: 48),
    10: const _TextConfig(offsetX: 0, offsetY: -30, fontSize: 48),
    12: const _TextConfig(offsetX: 0, offsetY: 0, fontSize: 48),
    20: const _TextConfig(offsetX: 0, offsetY: 0, fontSize: 30),
  };

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final savedSides = await StorageService.loadSides();
    final savedColor = await StorageService.loadColor();
    setState(() {
      _selectedSides = savedSides;
      _diceColor = savedColor;
      _dice = Dice(sides: _selectedSides);
      _isLoading = false;
    });
    _rollDice();
  }

  Future<void> _rollWithAnimation() async {
    if (_isRolling) return;
    setState(() {
      _isRolling = true;
    });

    const steps = 12;
    const stepDelay = Duration(milliseconds: 80);

    for (int i = 0; i < steps; i++) {
      final tempResult = _dice.roll();
      setState(() {
        _currentResult = tempResult;
      });
      await Future.delayed(stepDelay);
    }

    final finalResult = _dice.roll();
    setState(() {
      _currentResult = finalResult;
      _isRolling = false;
    });
  }

  void _rollDice() {
    if (_isRolling) return;
    setState(() {
      _currentResult = _dice.roll();
    });
  }

  void _changeSides(int newSides) {
    if (_isRolling) return;
    setState(() {
      _selectedSides = newSides;
      _dice = Dice(sides: _selectedSides);
    });
    StorageService.saveSides(newSides);
    _rollDice();
  }

  void _openColorPicker() async {
    if (_isRolling) return;
    final selectedColor = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ColorPickerScreen()),
    );
    if (selectedColor != null) {
      setState(() {
        _diceColor = selectedColor;
      });
      StorageService.saveColor(selectedColor);
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
    return 'другой';
  }


  Widget _buildDiceImage() {
    final config = _textConfigs[_selectedSides] ?? const _TextConfig(offsetX: 0, offsetY: 0, fontSize: 48);

    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/d$_selectedSides.svg',
          color: _diceColor,
          width: 200,
          height: 200,
        ),
        Transform.translate(
          offset: Offset(config.offsetX, config.offsetY),
          child: Text(
            '$_currentResult',
            style: TextStyle(
              fontSize: config.fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _availableSides.map((sides) {
                      final isSelected = _selectedSides == sides;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GestureDetector(
                          onTap: _isRolling ? null : () => _changeSides(sides),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.amber : Colors.grey.shade800,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                'd$sides',
                                style: TextStyle(
                                  color: isSelected ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const Spacer(),
              _buildDiceImage(),
              const Spacer(),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _isRolling ? null : _rollWithAnimation,
                    icon: const Icon(Icons.casino),
                    label: const Text('Бросить!'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      textStyle: const TextStyle(fontSize: 24),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: _isRolling ? null : _openColorPicker,
                    icon: const Icon(Icons.color_lens),
                    label: const Text('Изменить цвет кости'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextConfig {
  final double offsetX;
  final double offsetY;
  final double fontSize;

  const _TextConfig({
    required this.offsetX,
    required this.offsetY,
    required this.fontSize,
  });
}