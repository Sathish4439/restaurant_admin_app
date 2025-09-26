import 'package:flutter/material.dart';
import 'package:restaurent_admin_app/core/theme/app_color.dart';
import 'package:restaurent_admin_app/core/theme/app_font.dart';


class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
  
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppFonts.textStyle(
            fontSize: AppFonts.regular, fontWeight: FontWeight.bold),
      ),
    ),
    textTheme: TextTheme(
    
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.secondary)),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      hintStyle: AppFonts.textStyle(
          fontSize: AppFonts.regular, color: AppColors.textSecondary),
      labelStyle: AppFonts.textStyle(
          fontSize: AppFonts.regular, color: AppColors.textPrimary),
    ),
  );

  // Dark Theme (optional)
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: TextTheme(
   
    ),
  );
}
