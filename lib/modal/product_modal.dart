import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

Future addProductModal(
  BuildContext context, {
  String? barCode,
  String? name,
  String? category,
  double? content,
  String? unit,
}) async {
  // Create a text editing controller for each field
  final nameController = TextEditingController(text: name);
  final categoryController = TextEditingController(text: category);
  final contentController = TextEditingController(text: content?.toString());
  final unitController = TextEditingController(text: unit);
  final locationController = TextEditingController();
  final stockController = TextEditingController();
  final shelfController = TextEditingController();

  // Category need to be a dropdown, same with unit
  // Need a stock and shelf field

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownSearch(
              asyncItems: (String filter) async {
                final locations = await api.fetchLocations();
                return locations;
              },
              onChanged: (value) {
                debugPrint('Location: ${value!.id}');
                locationController.text = value.id.toString();
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Location",
                ),
              ),
              popupProps: const PopupProps.menu(
                fit: FlexFit.loose,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Name'),
              controller: nameController,
              textCapitalization: TextCapitalization.words,
            ),
            DropdownSearch(
              asyncItems: (String filter) async {
                final categories = await api.fetchCategories();
                return categories;
              },
              onChanged: (value) {
                debugPrint('Category: ${value!.id}');
                categoryController.text = value.id.toString();
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Category",
                ),
              ),
              popupProps: const PopupProps.menu(
                fit: FlexFit.loose,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Content'),
              controller: contentController,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Unit'),
              controller: unitController,
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // add the product to the database
                  final name = nameController.text;
                  final category = categoryController.text;
                  final content =
                      double.tryParse(contentController.text) ?? 0.0;
                  final unit = unitController.text;
                  final location = locationController.text;
                  final stock = stockController.text;
                  final shelf = shelfController.text;
                  debugPrint('Location: $location');

                  await api.storeProduct(
                    name: name,
                    category: category,
                    content: content,
                    unit: unit,
                    barCode: barCode ?? '',
                    location: location,
                    stock: stock,
                    shelf: shelf,
                  );

                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
