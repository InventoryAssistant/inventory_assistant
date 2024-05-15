import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/router.dart';
import 'package:inventory_assistant/misc/theme.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

bool autoLogin = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  autoLogin = !await api.isLoggedIn(checkAutoLogin: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GoRouter _router = routerGenerator(autoLogin);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Inventory Assistant',
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      routeInformationProvider: _router.routeInformationProvider,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }
}
