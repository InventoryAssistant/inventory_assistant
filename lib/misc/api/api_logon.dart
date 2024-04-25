import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_url.dart' as api;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create the storage
const storage = FlutterSecureStorage();

/// Store API token
storeToken(String value) async {
  await storage.write(key: "token", value: value);
}

/// Store login information
storeLoginInfo(String email, String password) async {
  await storage.write(key: "email", value: email);
  await storage.write(key: "password", value: password);
}

/// Get token from storage
Future<String> getToken() async {
  String? value = await storage.read(key: "token") ?? "no token";
  return Future.value(value);
}

/// Get login information from storage
Future<Map<String, String>> getLoginInfo() async {
  String? email = await storage.read(key: "email");
  String? password = await storage.read(key: "password");
  return {email!: password!};
}

/// Check if the user is logged in
Future<bool> isLoggedIn({bool autoLogin = false}) async {
  String? value = await storage.read(key: "token");

  // If it is used to determine auto login, check for email and password
  if (autoLogin) {
    value = await storage.read(key: "email");
    value = await storage.read(key: "password");
  }

  if (value != null) {
    return true;
  }
  return false;
}

/// Log user out
Future logOut() async {
  await storage.delete(key: 'email');
  await storage.delete(key: 'password');
  await storage.delete(key: 'token');
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

/// keep user logged in
Future<bool> autoLogin() async {
  // get login info
  final loginInfo = await getLoginInfo();

  // make login info into variables
  final email = loginInfo.keys.first;
  final password = loginInfo[email];

  // Print variables
  if (kDebugMode) {
    debugPrint(email);
    debugPrint(password);
  }

  // login with variables
  final response = await login(email, password);

  if (response.statusCode == 200) {
    // turn response into json and print it
    final jsonResponse = json.decode(response.body);

    if (kDebugMode) {
      debugPrint(jsonResponse["access_token"]);
    }

    // store bearer token
    storeToken(jsonResponse["access_token"]);
    return true;
  }

  return false;
}

/// Creates an account with given credentials
Future<http.Response> createAccount(String email, String password) {
  var url = "";
  url = '${api.getBaseUrl()}/api/auth/register';

  // Creates and posts the request.
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
