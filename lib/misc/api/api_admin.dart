import 'dart:convert';

import 'package:http/http.dart' as http;
import 'api_url.dart' as api;
import 'api_token.dart' as api_token;

/// Check if user is admin
Future<bool> isAdmin() async {
  bool isAdmin = await api_token.getIsAdmin();
  if (isAdmin) {
    return true;
  }

  final token = await api_token.getToken();

  // Check if user is admin
  isAdmin = await http.get(
    Uri.parse('${api.getApiBaseUrl()}/roles/get_roles'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  ).then((response) {
    if (response.statusCode != 200) {
      return false;
    }
    final data = jsonDecode(response.body);
    if (data['name'] == 'admin') {
      return true;
    }
    return false;
  });
  api_token.storeIsadmin(isAdmin);

  return isAdmin;
}
