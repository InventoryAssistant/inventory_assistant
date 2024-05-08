import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_assistant/modal/product_modal.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/widget/custom_drawer.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  ScanResult? scanResult;

  Map<String, dynamic> product = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    return Scaffold(
      appBar: const CustomAppBar(title: "Barcode Scanner", centerTitle: true),
      drawer: const CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: <Widget>[
          ElevatedButton.icon(
            onPressed: _scan,
            icon: const Icon(Icons.camera),
            label: const Text('Scan Product'),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    if (product['name'] != null)
                      ListTile(
                        title: const Text('Name'),
                        subtitle: Text(product['name']),
                      ),
                    if (product['content'] != null)
                      ListTile(
                        title: const Text('Content'),
                        subtitle:
                            Text("${product['content']} ${product['unit']}"),
                      ),
                    if (product['category'] != null)
                      ListTile(
                        title: const Text('Category'),
                        subtitle: Text(product['category']),
                      ),
                    if (scanResult != null)
                      ListTile(
                        title: const Text('Barcode'),
                        subtitle: Text(scanResult.rawContent),
                      ),
                    if (product['message'] != null)
                      ListTile(
                        title: Text(product['message']),
                      ),
                    if (product['error'] != null)
                      ListTile(
                        title: Text(product['error']),
                      ),
                  ],
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      addProductModal(
                        context,
                        barCode: scanResult?.rawContent,
                        name: product['name'],
                        category: product['category'],
                        content: product['content']?.toDouble(),
                        unit: product['unit'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scan() async {
    try {
      await BarcodeScanner.scan(
        options: const ScanOptions(),
      ).then((barcode) async {
        var data = await api.fetchBarcodeData(barcode);
        setState(() {
          scanResult = barcode;
          product = data;
        });
      });
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
