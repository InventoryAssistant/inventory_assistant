import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/base_item.dart';
import 'package:inventory_assistant/misc/api/api_url.dart' as api;
import 'package:inventory_assistant/misc/api/api_token.dart' as api_token;
import 'package:flutter/foundation.dart';

/// Store a new product in the database
Future storeProduct({
  required String name,
  required String category,
  required double content,
  required String unit,
  required String barcode,
  required int shelf,
  required int stock,
  required int location,
}) async {
  // Get the api token
  final token = await api_token.getToken();

  // Create the locations array for the request
  final locations = [
    {
      'id': location,
      'stock': stock,
      'shelf_amount': shelf,
    }
  ];

  // Send the request to the api
  final response = await http.post(
    Uri.parse('${api.getApiBaseUrl()}/products'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'name': name,
      'category_id': category,
      'content': content,
      'unit_id': unit,
      'barcode': barcode,
      'locations': locations,
    }),
  );

  // Check if the request was successful
  return response.statusCode == 201;
}

/// Get all categories from the api
Future<List<BaseItem>> fetchCategories() async {
  List<BaseItem> categories = [];

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        for (var i = 0; i < data.length; i++) {
          categories.add(BaseItem(
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

  return categories;
}

/// Get all units from the api
Future<List<BaseItem>> fetchUnits() async {
  List<BaseItem> units = [];

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/units'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        for (var i = 0; i < data.length; i++) {
          units.add(BaseItem(
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

  return units;
}

/// Get specific product from the api
Future<Map<String, dynamic>> fetchProduct(int id) async {
  Map<String, dynamic> product = {};

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/products/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        product = jsonDecode(response.body)['data'];
      } else {
        if (kDebugMode) {
          debugPrint('Request failed with status: ${response.statusCode}');
        }
        product = {
          'name': 'Product not found',
          'locations': [],
        };
      }
    });
  } catch (e) {
    // Handle any exceptions that occur
    if (kDebugMode) {
      debugPrint('Error: $e');
      return {'error': 'Something went wrong, try again later.'};
    }
  }

  return product;
}

/// get unit from product
Future<BaseItem> fetchUnitFromProduct(int id) async {
  BaseItem unit = BaseItem(id: 0, name: '');

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/products/$id/unit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        unit = BaseItem(
          id: data['id'],
          name: data['name'],
        );
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

  return unit;
}

/// Update a product in the database
Future<bool> updateProduct({
  required int id,
  required String name,
  required String categoryId,
  required double content,
  required String unitId,
  required String barcode,
  required int shelf,
  required int stock,
  required int locationId,
}) async {
  // Get the api token
  final token = await api_token.getToken();

  // Create the locations array for the request
  final locations = [
    {
      'id': locationId,
      'stock': stock,
      'shelf_amount': shelf,
    }
  ];

  // Send the request to the api
  final response = await http.put(
    Uri.parse('${api.getApiBaseUrl()}/products/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'name': name,
      'category_id': categoryId,
      'content': content,
      'unit_id': unitId,
      'barcode': barcode,
      'locations': locations,
    }),
  );

  debugPrint(response.body);

  // Check if the request was successful
  return response.statusCode == 200;
}
