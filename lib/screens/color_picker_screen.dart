import 'package:flutter/material.dart';

class ColorPickerScreen extends StatelessWidget {
  const ColorPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите цвет кости'),
      ),
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _buildColorOption(Colors.yellow, 'Жёлтый', context),
            _buildColorOption(Colors.red, 'Красный', context),
            _buildColorOption(Colors.blue, 'Синий', context),
            _buildColorOption(Colors.green, 'Зелёный', context),
            _buildColorOption(Colors.purple, 'Фиолетовый', context),
            _buildColorOption(Colors.pink, 'Розовый', context),
            _buildColorOption(Colors.orange, 'Оранжевый', context),
            _buildColorOption(Colors.teal, 'Бирюзовый', context),
          ],
        ),
      ),
    );
  }

  Widget _buildColorOption(Color color, String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, color);
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}