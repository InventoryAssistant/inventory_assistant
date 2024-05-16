import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:flutter/material.dart';
import 'package:inventory_assistant/modal/edit_product_modal.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/widget/custom_drawer.dart';
import 'package:inventory_assistant/widget/search.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Map<int, bool> state = {};
  bool canEdit = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    api.hasPermission(permission: 'update').then((value) {
      setState(() {
        canEdit = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Inventory", centerTitle: true),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          const Search(),
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
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
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
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
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
            ),
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
                        return InkWell(
                          onTap: () {
                            context.pushNamed(
                              'product',
                              pathParameters: {
                                'id': products.data?['data'][index]['id']
                                        .toString() ??
                                    '',
                              },
                            );
                          },
                          child: ListTile(
                            title: Text(
                                '${products.data?['data'][index]['name']} ${products.data?['data'][index]['content']} ${products.data?['data'][index]['unit'] ?? ''}'),
                            trailing: canEdit
                                ? IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await editProductModal(
                                        context,
                                        product: {
                                          'id': products.data?['data'][index]
                                              ['id'],
                                          'name': products.data?['data'][index]
                                              ['name'],
                                          'category_id': categoryId,
                                          'category': products.data?['data']
                                              [index]['category'],
                                          'content': products.data?['data']
                                              [index]['content'],
                                          'barcode': products.data?['data']
                                              [index]['barcode'],
                                          'location_id': products.data?['data']
                                              [index]['locations'][0]['id'],
                                          'location': products.data?['data']
                                                  [index]['locations'][0]
                                              ['address'],
                                          'stock': products.data?['data'][index]
                                                  ['locations'][0]['pivot']
                                              ['stock'],
                                          'shelf': products.data?['data'][index]
                                                  ['locations'][0]['pivot']
                                              ['shelf_amount'],
                                          'unit': products.data?['data'][index]
                                              ['unit'],
                                          'unit_id': products.data?['data']
                                              [index]['unit_id'],
                                        },
                                      );

                                      setState(() {
                                        future = api.fetchProductPage(
                                            products.data?['meta']['path'],
                                            products.data?['meta']
                                                ['current_page'],
                                            categoryId);
                                      });
                                    },
                                  )
                                : null,
                          ),
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
