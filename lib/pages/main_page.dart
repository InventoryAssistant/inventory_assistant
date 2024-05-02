import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    api.isLoggedIn(checkAutoLogin: true).then((isLoggedIn) {
      if (isLoggedIn) {
        context.go('/scanner');
      } else {
        context.go('/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Return a loading screen while the path is being determined
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
