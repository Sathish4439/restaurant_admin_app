import 'package:flutter/material.dart';

class AppFonts {
  // Extra small text
  static const double extraSmall = 10;

  // Small text
  static const double small = 12;

  // Regular/medium text
  static const double regular = 14;

  // Large text
  static const double large = 18;

  // Extra large text (titles/headings)
  static const double extraLarge = 22;

  // Huge text (optional, for main headings)
  static const double huge = 26;

  // Example reusable TextStyle
  static TextStyle textStyle({
    double fontSize = regular,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
