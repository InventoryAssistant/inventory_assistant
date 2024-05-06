import 'package:flutter/material.dart';
import 'package:inventory_assistant/home.dart';
import 'package:inventory_assistant/inventory.dart';
import 'package:inventory_assistant/login_screen.dart';
import 'package:inventory_assistant/scanner.dart';
import 'package:inventory_assistant/theme.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        // Placeholder routes for navigation
        '/home': (context) => const InventoryPage(),
        '/login': (context) => const InventoryPage(),
      },
      title: 'Inventory Assistant',
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      home: FutureBuilder(
        future: api.isAutoLogin(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              return const InventoryPage();
            } else {
              return const InventoryPage();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
