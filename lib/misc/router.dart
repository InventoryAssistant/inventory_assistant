import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/pages/inventory_page.dart';
import 'package:inventory_assistant/pages/login_page.dart';
import 'package:inventory_assistant/pages/product_page.dart';
import 'package:inventory_assistant/pages/admin_page.dart';
import 'package:inventory_assistant/pages/profile_page.dart';
import 'package:inventory_assistant/pages/scanner_page.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

GoRouter routerGenerator() {
  final router = GoRouter(
    initialLocation: '/scanner',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        redirect: (context, state) async {
          if (!await api.isLoggedIn()) {
            return '/login';
          }
          return null;
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
              return const InventoryPage();
            },
          ),
          GoRoute(
            name: 'product',
            path: 'product/:id',
            builder: (BuildContext context, GoRouterState state) {
              final int? id = int.tryParse(state.pathParameters['id']!);
              return ProductPage(id: id);
            },
          ),
          GoRoute(
            name: 'admin',
            path: 'admin',
            builder: (BuildContext context, GoRouterState state) {
              return const AdminPage();
            },
            redirect: (context, state) async {
              if (!await api.isAdmin()) {
                return '/login';
              }
              return null;
            },
          ),
          GoRoute(
            name: 'profile',
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return const ProfilePage();
            },
          ),
        ],
      ),
    ],
  );
  return router;
}
