import 'dart:convert';
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
              border: OutlineInputBorder(
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
                AsyncSnapshot<Map<String, dynamic>> category) {
              switch (category.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Loading...');
                default:
                  return SizedBox(
                    width: 1200,
                    height: 1200,
                    child: ListView.builder(
                      itemCount: category.data?['data'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: ListTile(
                                title: Text(
                                  category.data?['data'][index]['name'],
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: const Icon(Icons.add),
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
                                  return Text('${snapshot.error}');
                                } else {
                                  return const Text('Something went wrong');
                                }
                            }
                          },
                        );
 */
