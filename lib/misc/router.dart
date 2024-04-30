import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/main_screen.dart';
import 'package:inventory_assistant/login_screen.dart';
import 'package:inventory_assistant/home.dart';

GoRouter routerGenerator() {
  final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MainScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            name: 'login',
            path: 'login',
            builder: (BuildContext context, GoRouterState state) {
              debugPrint("Login");
              return const LoginScreen();
            },
          ),
          GoRoute(
            name: 'home',
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              debugPrint("Placeholder");
              return const Home();
            },
          ),
        ],
      ),
    ],
  );
  return router;
}
