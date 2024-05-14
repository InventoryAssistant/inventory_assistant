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
  Map<String, dynamic> product = {};
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

  getProduct() async {
    product = await api.fetchProduct(widget.id!);
    debugPrint('Product: $product');
    return product;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getProduct(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
                      shrinkWrap: true,
                      children: [
                        const ListTile(
                          title: Text(
                            'Details:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Category: ${product['category']}'),
                        ),
                        ListTile(
                          title: Text('Barcode: ${product['barcode']}'),
                        ),
                        ListTile(
                          title: Text(
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
                                  '${product['locations'][index]['address']}'),
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
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
