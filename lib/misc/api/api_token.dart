import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_logon.dart' as api_login;

const storage = FlutterSecureStorage();

const String _refreshToken = "refresh_token";
const String _accessToken = "access_token";
const String _autoLogin = "auto_login";
const String _isAdmin = "is_admin";

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

storeIsadmin(bool value) async {
  await storage.write(key: _isAdmin, value: value.toString());
}

/// Stores the user information
storeToken(String accessToken, String refreshToken, bool autoLogin) async {
  await _storeToken(accessToken);
  await _storeRefreshToken(refreshToken);
  await _storeAutoLogin(autoLogin);
}

/// Get token from storage
Future<String?> getToken() async {
  String? value = await storage.read(key: _accessToken);
  if (await api_login.isTokenExpired(token: value!)) {
    await api_login.refreshToken();
    value = await storage.read(key: _accessToken);
  }
  return Future.value(value);
}

Future<String?> getRefreshToken() async {
  String? value = await storage.read(key: _refreshToken);
  return Future.value(value);
}

Future<bool> getAutoLogin() async {
  bool value = await storage.read(key: _autoLogin) == 'true';
  return value;
}

Future<bool> getIsAdmin() async {
  bool value = await storage.read(key: _isAdmin) == 'true';
  return value;
}

clearToken() async {
  await storage.delete(key: _accessToken);
  await storage.delete(key: _refreshToken);
  await storage.delete(key: _autoLogin);
  await storage.delete(key: _isAdmin);
}
