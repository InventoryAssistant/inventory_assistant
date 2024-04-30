import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:inventory_assistant/misc/router.dart';

class Util {
  // static LoggedInStateInfo get loggedInStateInfo => LoggedInStateInfo();
  static GoRouter get router => routerGenerator();
  static Future<String> get initialRoute async => await _initialRoute();

  static Future<String> _initialRoute({bool checkAutoLogin = false}) async {
    final response = await api.isLoggedIn(checkAutoLogin: checkAutoLogin);
    if (!response) {
      return '/login';
    } else {
      return '/';
    }
  }
}
