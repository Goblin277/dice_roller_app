import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class StorageService {
  static const String _keySides = 'selected_sides';
  static const String _keyColor = 'dice_color';

  static Future<void> saveSides(int sides) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keySides, sides);
  }

  static Future<int> loadSides() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keySides) ?? 6;
  }

  static Future<void> saveColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyColor, color.value);
  }

  static Future<Color> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_keyColor);
    if (colorValue != null) {
      return Color(colorValue);
    }
    return Colors.amber;
  }
}