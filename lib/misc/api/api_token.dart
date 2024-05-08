import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_logon.dart' as api_login;

const storage = FlutterSecureStorage();

const String _refreshToken = "refresh_token";
const String _accessToken = "access_token";
const String _autoLogin = "auto_login";
const String _isAdmin = "is_admin";

/// Store access API token
_storeToken(String value) async {
  await storage.write(key: _accessToken, value: value);
}

/// Store refresh API token
_storeRefreshToken(String value) async {
  await storage.write(key: _refreshToken, value: value);
}

/// Store whether to auto login
_storeAutoLogin(bool value) async {
  await storage.write(key: _autoLogin, value: value.toString());
}

/// Store whether user is admin
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

/// Get refresh token from storage
Future<String?> getRefreshToken() async {
  return storage.read(key: _refreshToken);
}

/// Get whether to auto login from storage
Future<bool> getAutoLogin() async {
  bool value = await storage.read(key: _autoLogin) == 'true';
  return value;
}

/// Get whether user is admin from storage
Future<bool> getIsAdmin() async {
  bool value = await storage.read(key: _isAdmin) == 'true';
  return value;
}

/// Clear all tokens from storage
clearStorage() async {
  await storage.deleteAll();
}
