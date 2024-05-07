import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'api_url.dart' as api;
import 'dart:developer';
import 'package:flutter/foundation.dart';

/*

                    name: name,
                    category: category,
                    content: content,
                    unit: unit,
                    barCode: barCode,
*/
Future<Map<String, dynamic>> storeProduct({
  String? name,
  String? category,
  double? content,
  String? unit,
  String? barCode,
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
    }),
  );

  debugPrint('Response: ${response.body}');

  // Return the product
  return product;
}
