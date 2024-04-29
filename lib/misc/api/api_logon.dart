import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_url.dart' as api;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create the storage
const storage = FlutterSecureStorage();

const String _refreshToken = "refresh_token";
const String _accessToken = "access_token";
const String _autoLogin = "auto_login";

/// Store API token
_storeToken(String value) async {
  await storage.write(key: _accessToken, value: value);
}

_storeRefreshToken(String value) async {
  await storage.write(key: _refreshToken, value: value);
}

_storeAutoLogin(bool value) async {
  await storage.write(key: _autoLogin, value: value.toString());
}

/// Stores the user information
storeToken(String accessToken, String refreshToken, bool autoLogin) async {
  await _storeToken(accessToken);
  await _storeRefreshToken(refreshToken);
  await _storeAutoLogin(autoLogin);
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

  final token = await storage.read(key: "refresh_token");

  if (token == null) {
    return false;
  }

  // Check if the token is expired
  bool expired = await isTokenExpired(token: token);

  if (expired) {
    return false;
  } else {
    return true;
  }
}

/// Check if the token is expired
Future<bool> isTokenExpired({
  required String token,
}) async {
  // Uses the API library to check if the token is expired
  return http.get(
    Uri.parse('${api.getApiBaseUrl()}/auth/validate'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  ).then((response) {
    if (response.statusCode == 200) {
      return false;
    }
    return true;
  });
}

/// Log user out
Future logOut() async {
  final token = await storage.read(key: _accessToken);
  await http.post(
    Uri.parse('${api.getApiBaseUrl()}/auth/logout'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  await storage.delete(key: _accessToken);
  await storage.delete(key: _refreshToken);
  await storage.delete(key: _autoLogin);
}

/// Log user in
Future<bool> login(
  final String email,
  final String password,
  final bool autologin,
) async {
  final String url = '${api.getApiBaseUrl()}/auth/login';

  final response = await http
      .post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  )
      .then((response) async {
    if (response.statusCode != 200) {
      return false;
    }
    Map<String, dynamic> parsed = jsonDecode(response.body);

    if (kDebugMode) {
      debugPrint(response.body);
    }

    // Uses API library to store token
    await storeToken(
        parsed['access_token'], parsed['refresh_token'], autologin);

    return true;
  });

  return response;
}

// TODO: Make it function like the login function
/// Refresh token
Future<http.Response> refreshToken() async {
  final String? token = await storage.read(key: _refreshToken);

  final String url = '${api.getApiBaseUrl()}/auth/refresh';

  return http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
}
