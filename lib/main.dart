import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_assistant/theme.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Assistant',
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      home: const ScannerPage(title: 'Scan Product'),
    );
  }
}

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.title});

  final String title;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  ScanResult? scanResult;

  Map<String, dynamic> product = {'name': null, 'category': null};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: _scan,
            icon: const Icon(Icons.camera),
            label: const Text('Scan Product'),
          ),
          if (scanResult != null)
            Card(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Barcode'),
                    subtitle: Text(scanResult.rawContent),
                  ),
                  if (product['name'] != null)
                    ListTile(
                      title: const Text('Name'),
                      subtitle: Text(product['name']),
                    ),
                  if (product['category'] != null)
                    ListTile(
                      title: const Text('Category'),
                      subtitle: Text(product['category']),
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    final scanResult = this.scanResult;
    try {
      String? results = scanResult?.rawContent;
      var url = Uri.parse('http://10.130.56.51/api/products/barcode/$results');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        // If the response is data it is from the local database
        if (json.containsKey("data")) {
          setState(() {
            product['name'] = jsonDecode(response.body)['data']['name'];
            product['category'] = jsonDecode(response.body)['data']['category'];
          });
        }

        // If the response is instore it is from the backup database
        if (json.containsKey("instore")) {
          setState(() {
            product['name'] = jsonDecode(response.body)['instore']
                    ['description'] +
                " " +
                jsonDecode(response.body)['instore']['name'];
            product['category'] = "None";
          });
        }

        log(jsonEncode(product));
      } else {
        // Handle error response
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur
      log('Error: $e');
    }
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: const ScanOptions(),
      );
      setState(() => scanResult = result);
      fetchData();
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
