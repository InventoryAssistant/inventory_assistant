import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'api_url.dart' as api;
import 'dart:developer';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> fetchBarcodeData(ScanResult? scanResult) async {
  Map<String, dynamic> product = {};

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/products/barcode/${scanResult?.rawContent}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
    ).then((response) {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        // If the response is wrapped in data it is from inventory assistants database
        if (json.containsKey("data")) {
          product['name'] = jsonDecode(response.body)['data']['name'];
          product['content'] = "${jsonDecode(response.body)['data']['content']} ${jsonDecode(response.body)['data']['unit'] ?? ''}";
          product['category'] = jsonDecode(response.body)['data']['category'];
        }

        // If the response is wrapped in instore it is from the sailing groups database
        if (json.containsKey("instore")) {
          product['name'] = "${jsonDecode(response.body)['instore']['description']} ${jsonDecode(response.body)['instore']['name']}";
          product['content'] = "${jsonDecode(response.body)['instore']['contents']} ${jsonDecode(response.body)['instore']['contentsUnit']}";
          product['category'] = "None";
        }
      }else{
        // Handle error response
        product['status_code'] = 'Request failed with status: ${response.statusCode}';
        product['message'] = jsonDecode(response.body)['message'];
        if (kDebugMode) {
          log('Request failed with status: ${response.statusCode}');
        }
      }
    });
  } catch (e) {
    product['error'] = 'Error: $e';
    // Handle any exceptions that occur
    if (kDebugMode) {
      log('Error: $e');
    }
  }

  // Return the product
  return product;
}
