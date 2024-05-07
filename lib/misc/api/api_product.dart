import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_assistant/misc/location.dart';
import 'api_url.dart' as api;
import 'package:flutter/foundation.dart';

/// Store a product in the database
Future<Map<String, dynamic>> storeProduct({
  required String name,
  required String category,
  required double content,
  required String unit,
  required String barCode,
  required String shelf,
  required String stock,
  required String location,
}) async {
  Map<String, dynamic> product = {};

  final response = await http.post(
    Uri.parse('${api.getApiBaseUrl()}/products'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'category': category,
      'content': content,
      'unit': unit,
      'barcode': barCode,
      'shelf': shelf,
      'stock': stock,
      'location': location,
    }),
  );

  debugPrint('Response: ${response.body}');

  // Return the product
  return product;
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
