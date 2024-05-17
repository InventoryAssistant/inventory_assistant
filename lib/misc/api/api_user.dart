import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/base_item.dart';
import 'package:inventory_assistant/misc/api/api_url.dart' as api;
import 'package:inventory_assistant/misc/api/api_token.dart' as api_token;
import 'package:flutter/foundation.dart';

/// Fetch roles
Future<List<BaseItem>> fetchRoles() async {
  List<BaseItem> role = [];

  final token = await api_token.getToken();

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
  final token = await api_token.getToken();

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
      debugPrint("Error: $e");
    }
    return Future.error('Error: $e');
  }

  return user;
}

/// Fetch all users by location
Future<List<dynamic>> fetchUsersByLocation(location) async {
  List<dynamic> users = [];

  final token = await api_token.getToken();

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
      debugPrint("Error: $e");
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

/// Get current user information
Future getCurrentUser() async {
  Map<String, dynamic> user = {};
  final token = await api_token.getToken();

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        user = {
          'id': data['id'],
          'first_name': data['first_name'],
          'last_name': data['last_name'],
          'email': data['email'],
          'phone': data['phone_number'],
          'location': data['location_id'],
        };
      } else {
        if (kDebugMode) {
          debugPrint('Request failed with status: ${response.statusCode}');
        }

        user = {
          'id': 0,
          'first_name': 'Failed to get user',
          'last_name': '',
          'email': '',
          'phone': '',
          'location': 0,
        };
      }
    });
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      debugPrint('Error: $e');
    }
  }

  return user;
}

/// Update user information
Future<bool> updateUser({
  required int userId,
  required String firstName,
  required String lastName,
  required String email,
  required String phoneNumber,
  required int locatioId,
  required String? password,
}) async {
  final token = await api_token.getToken();

  try {
    return await http
        .put(
      Uri.parse('${api.getApiBaseUrl()}/user/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'location_id': locatioId,
        if (password != null) 'password': password,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        return true;
      } else {
        if (kDebugMode) {
          debugPrint('Request failed with status: ${response.statusCode}');
          debugPrint('Body: ${response.body}');
        }
        return false;
      }
    });
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      debugPrint('Error: $e');
    }
    return false;
  }
}
