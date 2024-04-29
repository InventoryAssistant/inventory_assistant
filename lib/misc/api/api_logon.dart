import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_url.dart' as api;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create the storage
const storage = FlutterSecureStorage();

const String _refreshToken = "refresh_token";
const String _accessToken = "access_token";
const String _autoLogin = "auto_login";

/// Store API token
storeToken(String value) async {
  await storage.write(key: _accessToken, value: value);
}

storeRefreshToken(String value) async {
  await storage.write(key: _refreshToken, value: value);
}

storeAutoLogin(bool value) async {
  await storage.write(key: _autoLogin, value: value.toString());
}

/// Get token from storage
Future<String> getToken() async {
  String? value = await storage.read(key: _accessToken) ?? "no token";
  return Future.value(value);
}

/// Check if the user is logged in
Future<bool> isAutoLogin() async {
  bool? autoLogin = await storage.read(key: _autoLogin) == "true";

  if (!autoLogin) {
    return false;
  }

  String? token = await storage.read(key: _refreshToken);

  if (token != null) {
    return true;
  }
  return false;
}

/// Log user out
Future logOut() async {
  await storage.delete(key: _accessToken);
  await storage.delete(key: _refreshToken);
  await storage.delete(key: _autoLogin);
}

/// Log user in
Future<http.Response> login(final email, final password) {
  final String url = '${api.getApiBaseUrl()}/auth/login';

  return http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
}
