import 'package:flutter/material.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.lightBlue,
      background: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.lightBlue,
      foregroundColor: Colors.white,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Colors.lightBlue,
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.lightBlue,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.blueGrey[100];
            }
            return Colors.lightBlue;
          },
        ),
        foregroundColor: MaterialStateColor.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return Colors.black;
          },
        ),
        minimumSize: MaterialStateProperty.all(
          const Size(double.infinity, double.infinity),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color.fromRGBO(70, 130, 180, 1.0),
      background: const Color.fromRGBO(60, 60, 60, 1.0),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(80, 140, 200, 1.0),
      foregroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Color.fromRGBO(80, 140, 200, 1),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color.fromRGBO(80, 140, 200, 1),
      contentTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
  );
}
