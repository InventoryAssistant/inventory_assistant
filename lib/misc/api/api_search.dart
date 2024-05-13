import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_url.dart' as api;
import 'dart:developer';
import 'package:flutter/foundation.dart';

Future<Map<String, dynamic>> search(query) async {
  Map<String, dynamic> products = {};

  if(query == ""){
    return Future.error("Empty query");
  }

  try {
    await http.get(
      Uri.parse('${api.getApiBaseUrl()}/products/search/$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    ).then((response) {
      if (response.statusCode == 200) {
        // If OK response decode response and set to categories variable
        var json = jsonDecode(response.body);

        if (kDebugMode) {
          debugPrint(jsonEncode(response.body));
        }

        products = json;
      } else {
        // Handle error response
        if (kDebugMode) {
          log('Request failed with status: ${response.statusCode}');
          log('Request failed with message: ${jsonDecode(response.body)['message']}');
        }
        return Future.error("Request failed with status: ${response.statusCode} and message: ${jsonDecode(response.body)['message']}");
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