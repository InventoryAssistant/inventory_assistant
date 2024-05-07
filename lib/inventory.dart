import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory"), centerTitle: true),
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).secondaryHeaderColor,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.zero),
                borderSide: BorderSide.none,
              ),
              labelText: 'Search',
              hintText: 'Search',
            ),
          ),
          FutureBuilder(
            future: api.fetchCategories(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> categories) {
              switch (categories.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Loading...');
                default:
                  return SizedBox(
                    width: 1200,
                    height: 1200,
                    child: ListView.builder(
                      itemCount: categories.data?['data'].length,
                      itemBuilder: (BuildContext context, int index) {
                        bool isExpanded = false;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: ExpansionTile(
                                title: Text(
                                  categories.data?['data'][index]['name'],
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onExpansionChanged: (value) {
                                  isExpanded = value;
                                },
                                trailing: isExpanded
                                    ? const Icon(Icons.remove)
                                    : const Icon(Icons.add),
                                children: <Widget>[
                                  products(
                                      categories.data?['data'][index]['id']),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget products(int categoryId) {
    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: api.fetchInventoryByUserLocation(categoryId),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> products) {
            switch (products.connectionState) {
              case ConnectionState.waiting:
                return const Text('Loading...');
              default:
                return SizedBox(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: products.data?['data'].length,
                        itemBuilder: (BuildContext context, int index) {
                          bool isExpanded = false;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                    '${products.data?['data'][index]['name']} ${products.data?['data'][index]['content']} ${products.data?['data'][index]['unit'] ?? ''}'),
                                trailing: const Icon(Icons.edit),
                              ),
                            ],
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, right: 5),
                            child: ElevatedButton(
                              onPressed: null,
                              child: Text('Prev'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, left: 5),
                            child: ElevatedButton(
                              onPressed: () {
                                  // api.fetchPage(products.data?['links']['next']);
                              },
                              child: Text('Next'),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
            }
          },
        ),
      ],
    );
  }
}

/* TODO: this shit

                        return FutureBuilder(
                          future: api.fetchProductsByCategories(),
                          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const Text('Loading...');
                              default:
                                if (snapshot.data != null) {
                                  return SizedBox(
                                    width: 1200,
                                    height: 1200,
                                    child: ListView.builder(
                                      itemCount: snapshot.data?[category.data?['data'][index]['name']].length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Card(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 10, right: 10),
                                          child: Column(
                                            children: <Widget>[
                                              ListTile(
                                                title: Text(
                                                  snapshot.data?[category.data?['data'][index]['name']][index]
                                                  ['name'],
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text(
                                                  "${snapshot.data?[category.data?['data'][index]['name']][index]['content']} ${snapshot.data?[category.data?['data'][index]['name']][index]['unit'] ?? ''}",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                trailing: const Icon(Icons.edit),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  reext('${snapshot.error}');
                                } else {
                                  return const Text('Something went wrong');
                                }
                            }
                          },
                        );
 */
