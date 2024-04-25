import 'package:flutter/material.dart';
import 'package:inventory_assistant/login_screen.dart';
import 'package:inventory_assistant/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Assistant',
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      home: const LoginScreen(),
    );
  }
}
