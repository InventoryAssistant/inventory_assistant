import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/util.dart';
import 'package:inventory_assistant/theme.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await api.isLoggedIn(checkAutoLogin: true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = Util.router;

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
