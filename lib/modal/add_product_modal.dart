import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

Future addProductModal(
  BuildContext context, {
  String? barcode,
  String? name,
  String? category,
  double? content,
  String? unit,
}) async {
  // All of the controllers
  final nameController = TextEditingController(text: name);
  final categoryController = TextEditingController(text: category);
  final contentController = TextEditingController(text: content?.toString());
  final unitController = TextEditingController(text: unit);
  final locationController = TextEditingController();
  final stockController = TextEditingController();
  final shelfController = TextEditingController();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownSearch(
              asyncItems: (String filter) async {
                return api.fetchLocations();
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
                return api.fetchCategories();
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
                return api.fetchUnits();
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
                    barcode: barcode ?? '',
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
