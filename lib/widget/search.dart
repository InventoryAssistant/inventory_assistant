import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
        isFullScreen: false,
        viewShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            controller: controller,
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: const Icon(Icons.search),
          );
        },
        suggestionsBuilder:(BuildContext context, SearchController controller) async {
          String query = controller.text;
          List<dynamic> products = [];

          if (query.isNotEmpty) {
            products = await api.search(query);
          }

          return List<ListTile>.generate(products.length, (int index) {
            final product = products[index];
            return ListTile(
              title: Text(
                  "${product['name']} ${product['content']} ${product['unit'] ?? ''}"),
              onTap: () {
                // TODO: go to product page when product page is ready
              },
            );
          });
        });
  }
}
