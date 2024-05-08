import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/base_item.dart';
import 'api_url.dart' as api;
import 'dart:developer';
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
          log('Request failed with status: ${response.statusCode}');
        }
      }
    });
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      debugPrint('Error: $e');
      log('Error: $e');
    }
  }

  return location;
}
