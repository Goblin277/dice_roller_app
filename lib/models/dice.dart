import 'dart:math';

class Dice {
  final int sides;
  final Random _random = Random();

  Dice({required this.sides});

  int roll() {
    return _random.nextInt(sides) + 1;
  }
}