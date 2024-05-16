import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/base_item.dart';
import 'api_token.dart';
import 'api_url.dart' as api;
import 'dart:developer';
import 'package:flutter/foundation.dart';

/// Fetch roles
Future<List<BaseItem>> fetchRoles() async {
  List<BaseItem> role = [];

  final token = await getToken();

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/roles'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        for (var i = 0; i < data.length; i++) {
          role.add(BaseItem(
            id: data[i]['id'],
            name: data[i]['name'],
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

  return role;
}

/// Store user
Future<Map<String, dynamic>> storeUser({
  required String firstName,
  required String lastName,
  required int locationId,
  required int roleId,
  required String email,
  required String phoneNumber,
  required String password,
}) async {
  Map<String, dynamic> user = {};

  // Get the api token
  final token = await getToken();

  // try api call to store user
  try {
    await http
        .post(
      Uri.parse('${api.getApiBaseUrl()}/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'location_id': locationId,
        'role_id': roleId,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
      }),
    )
        .then((response) {
      if (response.statusCode == 201) {
        // If OK return 201 status
        user.addAll({'status' : response.statusCode});
      } else {
        // Handle error response
        if (kDebugMode) {
          debugPrint('Request failed with status: ${response.statusCode}');
          debugPrint('Request failed with message: ${jsonDecode(response.body)['message']}');
        }
        user = jsonDecode(response.body);
        user.addAll({'status' : response.statusCode});
      }
    });
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      log("Error: $e");
    }
    return Future.error('Error: $e');
  }

  return user;
}

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
          debugPrint('Request failed with status: ${response.statusCode}');
          debugPrint('Request failed with message: ${jsonDecode(response.body)['message']}');
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
