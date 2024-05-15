import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

final TextEditingController nameController = TextEditingController();
final TextEditingController categoryController = TextEditingController();
final TextEditingController contentController = TextEditingController();
final TextEditingController unitController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController stockController = TextEditingController();
final TextEditingController shelfController = TextEditingController();
Map<String, dynamic> product = {};

_setProductData(Map<String, dynamic> product) {
  nameController.text = product['name'];
  categoryController.text = product['category_id'].toString();
  contentController.text = product['content'].toString();
  unitController.text = product['unit_id'].toString();
  locationController.text = product['location_id'].toString();
  stockController.text = product['stock'].toString();
  shelfController.text = product['shelf'].toString();
}

Future editProductModal(
  BuildContext context, {
  required Map<String, dynamic> product,
}) async {
  _setProductData(product);
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownSearch(
              asyncItems: (String filter) async {
                final locations = await api.fetchLocations();
                return locations;
              },
              onChanged: (value) {
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
            DropdownSearch(
              asyncItems: (String filter) async {
                final categories = await api.fetchUnits();
                return categories;
              },
              onChanged: (value) {
                unitController.text = value.id.toString();
              },
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Unit",
                ),
              ),
              popupProps: const PopupProps.menu(
                fit: FlexFit.loose,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Stock'),
              controller: stockController,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Shelf'),
              controller: shelfController,
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
                  final location = int.tryParse(locationController.text) ?? 0;
                  final stock = int.tryParse(stockController.text) ?? 0;
                  final shelf = int.tryParse(shelfController.text) ?? 0;

                  await api.storeProduct(
                    name: name,
                    category: category,
                    content: content,
                    unit: unit,
                    barcode: product['barcode'] ?? '',
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
