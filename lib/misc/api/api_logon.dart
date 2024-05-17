import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_url.dart' as api;
import 'api_token.dart' as api_token;

/// Check if the user is logged in
Future<bool> isLoggedIn({bool checkAutoLogin = false}) async {
  if (checkAutoLogin) {
    bool autoLogin = await api_token.getAutoLogin();

    if (!autoLogin) {
      return false;
    }
  }

  final token = await api_token.getRefreshToken();

  if (token == null) {
    return false;
  }

  // Check if the token is expired
  bool isExpired = !await isTokenExpired(token: token);

  return isExpired;
}

/// Check if the token is expired
Future<bool> isTokenExpired({
  required String token,
}) async {
  // Uses the API library to check if the token is expired
  return http.post(
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
  final token = await api_token.getToken();
  await http.post(
    Uri.parse('${api.getApiBaseUrl()}/auth/logout'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  await api_token.clearStorage();
}

/// Log user in
Future<bool> login(
  final String email,
  final String password,
  final bool autologin,
) async {
  await api_token.clearStorage();
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

    // Saves the new tokens
    await api_token.storeToken(
        parsed['access_token'], parsed['refresh_token'], autologin);

    return true;
  });

  return response;
}

/// Refresh token
refreshToken() async {
  final String? token = await api_token.getRefreshToken();

  final String url = '${api.getApiBaseUrl()}/auth/refresh';

  bool response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  ).then((response) async {
    if (response.statusCode != 200) {
      return false;
    }
    Map<String, dynamic> parsed = jsonDecode(response.body);

    if (kDebugMode) {
      debugPrint(response.body);
    }

    final autologin = await api_token.getAutoLogin();

    // Saves the new token
    await api_token.storeToken(parsed['access_token'], token!, autologin);
    return true;
  });

  return response;
}
