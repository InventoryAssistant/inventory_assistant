import 'dart:convert';

import 'package:http/http.dart' as http;
import 'api_url.dart' as api;
import 'api_token.dart' as api_token;

/// Check if user is admin
Future<bool> isAdmin() async {
  final token = await api_token.getToken();
  // Uses the API library to check if the token is expired
  return http.post(
    Uri.parse('${api.getApiBaseUrl()}/roles/get_roles'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  ).then((response) {
    final data = jsonDecode(response.body);
    print(data);
    if (data.name == 'admin') {
      return true;
    }
    return false;
  });
}
