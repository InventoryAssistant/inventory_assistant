import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:flutter/material.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/widget/custom_drawer.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Map<int, bool> state = {};

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Inventory", centerTitle: true),
      drawer: const CustomDrawer(),
      body: Column(
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
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                categories(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categories() {
    return FutureBuilder(
      future: api.fetchInventoryCategories(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, dynamic>> categories) {
        if (categories.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            controller: _scrollController,
            itemCount: categories.data?['data'].length,
            itemBuilder: (BuildContext context, int index) {
              return StatefulBuilder(builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      clipBehavior: Clip.antiAlias,
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(
                            categories.data?['data'][index]['name'],
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
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
        } else if (categories.hasError) {
          return Text('${categories.error}');
        } else {
          return const Text('');
        }
      },
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
            if (products.hasData) {
              return SizedBox(
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
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
                                      future = api.fetchProductPage(
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
                                      future = api.fetchProductPage(
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
            } else if (products.hasError) {
              return Text('${products.error}');
            } else {
              return const Text('');
            }
          },
        );
      },
    );
  }
}
