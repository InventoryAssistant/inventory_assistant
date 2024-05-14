import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/base_item.dart';
import 'package:inventory_assistant/misc/api/api_url.dart' as api;
import 'package:flutter/foundation.dart';

/// Get location by id
Future<BaseItem> getLocationById(int locationId) async {
  BaseItem location = BaseItem(id: 0, name: '');

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/locations/$locationId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        location = BaseItem(
          id: data['id'],
          name: data['address'],
        );
      } else {
        if (kDebugMode) {
          debugPrint('Request failed with status: ${response.statusCode}');
        }
        location = BaseItem(id: 0, name: 'Falied to get location');
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
