import 'package:flutter/material.dart';

ThemeData lightDatatheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: Colors.red.shade600,
    onPrimary: Colors.white,
    secondary: Colors.grey.shade300,
    onSecondary: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    tertiary: Colors.grey.shade500,
  ),
  scaffoldBackgroundColor: Colors.grey.shade200,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.red.shade800,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    height: 70,
    indicatorColor: Colors.red.shade100,
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontWeight: FontWeight.w500),
    ),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (states) => IconThemeData(
        color:
            states.contains(WidgetState.selected)
                ? Colors.red.shade600
                : Colors.grey,
      ),
    ),
  ),
);
