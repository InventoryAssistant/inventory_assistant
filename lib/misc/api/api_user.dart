import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/base_item.dart';
import 'api_token.dart';
import 'api_url.dart' as api;
import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Fetch all users by location
Future<List<dynamic>> fetchUsersByLocation(location) async {
  List<dynamic> users = [];

  final token = await getToken();

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/users/location/$location'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // If OK response decode response and set to categories variable
        users = jsonDecode(response.body)['data'];
      } else {
        // Handle error response
        if (kDebugMode) {
          log('Request failed with status: ${response.statusCode}');
          log('Request failed with message: ${jsonDecode(response.body)['message']}');
        }
        return Future.error(
            "Request failed with status: ${response.statusCode} and message: ${jsonDecode(response.body)['message']}");
      }
    });
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      log("Error: $e");
    }
    return Future.error('Error: $e');
  }

  return users;
}

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
