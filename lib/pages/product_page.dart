import 'package:flutter/material.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:inventory_assistant/widget/custom_drawer.dart';

class ProductPage extends StatefulWidget {
  final int? id;
  const ProductPage({super.key, required this.id});

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  bool canEdit = false;

  @override
  void initState() {
    getProduct();

    api.hasPermission(permission: 'update').then((value) {
      setState(() {
        canEdit = value;
      });
    });

    super.initState();
  }

  Future<Map<String, dynamic>> getProduct() async {
    final Map<String, dynamic> product = await api.fetchProduct(widget.id!);
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProduct(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> productData) {
        final Map<String, dynamic> product = productData.data ?? {};
        if (productData.connectionState == ConnectionState.done &&
            product['error'] == null) {
          return Scaffold(
            appBar: CustomAppBar(
              title: '${product['name']}',
              trailing: canEdit
                  ? IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Edit the product
                      },
                    )
                  : const SizedBox(),
            ),
            drawer: const CustomDrawer(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListView(
                      padding: const EdgeInsets.all(10.0),
                      shrinkWrap: true,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Details:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                          child: Text('Category: ${product['category']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                          child: Text('Barcode: ${product['barcode']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                          child: Text(
                              'Content: ${product['content']} ${product['unit']}'),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text(
                            'Locations:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: product['locations'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                  '${product['locations'][index]['address']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                  'Stock: ${product['locations'][index]['pivot']['stock']} Shelf: ${product['locations'][index]['pivot']['shelf_amount']}'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else if (product['error'] != null) {
          return Scaffold(
            appBar: const CustomAppBar(
              title: 'Error',
            ),
            drawer: const CustomDrawer(),
            body: Center(
              child: Text(
                '${product['error']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
