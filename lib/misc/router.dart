import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/home.dart';
import 'package:inventory_assistant/pages/main_page.dart';
import 'package:inventory_assistant/pages/login_page.dart';
import 'package:inventory_assistant/pages/scanner_page.dart';

GoRouter routerGenerator() {
  final router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MainPage();
        },
        routes: <RouteBase>[
          GoRoute(
            name: 'login',
            path: 'login',
            builder: (BuildContext context, GoRouterState state) {
              return const LoginPage();
            },
          ),
          GoRoute(
            name: 'scanner',
            path: 'scanner',
            builder: (BuildContext context, GoRouterState state) {
              return const ScannerPage();
            },
          ),
          GoRoute(
            name: 'inventory',
            path: 'inventory',
            builder: (BuildContext context, GoRouterState state) {
              return const Home();
            },
          ),
          GoRoute(
            name: 'admin',
            path: 'admin',
            builder: (BuildContext context, GoRouterState state) {
              return const Home();
            },
          ),
          GoRoute(
            name: 'profile',
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const Home();
            },
          ),
        ],
      ),
    ],
  );
  return router;
}
