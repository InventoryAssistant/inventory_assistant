import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/api/api_lib.dart';
import 'api_url.dart' as api;
import 'dart:developer';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> fetchInventoryCategories() async {
  Map<String, dynamic> categories = {};

  // Try api call to categories index end point
  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // If OK response decode response and set to categories variable
        var json = jsonDecode(response.body);

        categories = json;
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

  return categories;
}

Future<Map<String, dynamic>> fetchInventoryByUserLocation(categoryId) async {
  Map<String, dynamic> products = {};

  final token = await getToken();

  final queryParameters = {
    'category_id': '$categoryId',
    'paginate' : '5',
  };

  var uri = Uri.http(api.ipAddress, '/api/products/location', queryParameters);

  // try api call to get products by user location end point
  try {
    await http.get(
      Uri.parse('$uri'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // If OK response decode response and set to products variable
        var json = jsonDecode(response.body);

        products = json;
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

  return products;
}

Future<Map<String, dynamic>> fetchPage(url, page, categoryId) async {
  Map<String, dynamic> products = {};

  final token = await getToken();

  // try api call to page end point
  try {
    await http.get(
      Uri.parse('$url').replace(queryParameters: {
        'page' : '$page',
        'category_id' : '$categoryId',
        'paginate' : '5',
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // If OK response decode response and set to products variable
        var json = jsonDecode(response.body);

        products = json;
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

  return products;
}
