import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/base_item.dart';
import 'api_url.dart' as api;
import 'api_token.dart' as api_token;
import 'package:flutter/foundation.dart';

/// Fetch all locations from the database
Future<List<BaseItem>> fetchLocations() async {
  List<BaseItem> location = [];

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/locations'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        for (var i = 0; i < data.length; i++) {
          location.add(BaseItem(
            id: data[i]['id'],
            name: data[i]['address'],
          ));
        }
      } else {
        if (kDebugMode) {
          debugPrint('Request failed with status: ${response.statusCode}');
        }
      }
    });
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      debugPrint('Error: $e');
    }
  }

  return location;
}

/// Check if the user has permission
Future<bool> hasPermission({required String permission}) async {
  final token = await api_token.getToken();
  try {
    final response = await http.get(
      Uri.parse('${api.getApiBaseUrl()}/auth/ability/$permission'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['has_ability'] == true) {
      return true;
    }
    if (response.statusCode != 200) {
      if (kDebugMode) {
        debugPrint('Request failed with status: ${response.statusCode}');
      }
    }
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      debugPrint('Error: $e');
    }
  }

  return false;
}
