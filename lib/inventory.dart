import 'dart:developer';

import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:flutter/material.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Map<int, bool> state = {};

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
            future: api.fetchInventoryCategories(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> categories) {
              switch (categories.connectionState) {
                case ConnectionState.waiting:
                  return const Text('Loading...');
                default:
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.data?['data'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return StatefulBuilder(builder: (context, setState) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Card(
                              clipBehavior: Clip.antiAlias,
                              margin: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text(
                                    categories.data?['data'][index]['name'],
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  trailing: state[index] ?? false
                                      ? const Icon(Icons.remove)
                                      : const Icon(Icons.add),
                                  onExpansionChanged: (bool value) {
                                    setState(() {
                                      state[index] = value;
                                    });
                                  },
                                  children: <Widget>[
                                    products(
                                      categories.data?['data'][index]['id'],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      });
                    },
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget products(int categoryId) {
    var future = api.fetchInventoryByUserLocation(categoryId);
    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder(
          future: future,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> products) {
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
                              onPressed: products.data?['links']['prev'] != null
                                  ? () {
                                      setState(() {
                                        future = api.fetchPage(
                                            products.data?['meta']['path'],
                                            products.data?['meta']
                                                    ['current_page'] -
                                                1,
                                            categoryId);
                                      });
                                    }
                                  : null,
                              child: const Text('Prev'),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10, left: 5),
                            child: ElevatedButton(
                              onPressed: products.data?['links']['next'] != null
                                  ? () {
                                      setState(() {
                                        future = api.fetchPage(
                                            products.data?['meta']['path'],
                                            products.data?['meta']
                                                    ['current_page'] +
                                                1,
                                            categoryId);
                                      });
                                    }
                                  : null,
                              child: const Text('Next'),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
            }
          },
        );
      },
    );
  }
}
