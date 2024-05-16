import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

final TextEditingController nameController = TextEditingController();
final TextEditingController categoryController = TextEditingController();
final TextEditingController contentController = TextEditingController();
final TextEditingController unitController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController stockController = TextEditingController();
final TextEditingController shelfController = TextEditingController();
final TextEditingController barcodeController = TextEditingController();
Map<String, dynamic> product = {};

_setProductData(Map<String, dynamic> product) {
  nameController.text = product['name'];
  categoryController.text = product['category_id'].toString();
  contentController.text = product['content'].toString();
  unitController.text = product['unit_id'].toString();
  locationController.text = product['location_id'].toString();
  stockController.text = product['stock'].toString();
  shelfController.text = product['shelf'].toString();
  barcodeController.text = product['barcode'].toString();
}

Future editProductModal(
  BuildContext context, {
  required Map<String, dynamic> product,
}) async {
  _setProductData(product);

  // Create a global key for the form
  final formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Edit Product'),
            content: Form(
              key: formKey,
              onChanged: () {
                if (formKey.currentState!.mounted) {
                  setState(() {
                    isFormValid = formKey.currentState!.validate();
                  });
                }
              },
              child: Column(
                children: [
                  DropdownSearch(
                    asyncItems: (String filter) async {
                      final locations = await api.fetchLocations();
                      return locations;
                    },
                    selectedItem: product['location'],
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      labelText: 'Name',
                    ),
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Barcode',
                      labelText: 'Barcode',
                    ),
                    controller: barcodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(20),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a barcode';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownSearch(
                    asyncItems: (String filter) async {
                      final categories = await api.fetchCategories();
                      return categories;
                    },
                    selectedItem: product['category'],
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Content',
                      labelText: 'Content',
                    ),
                    controller: contentController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      // if value is above 65536
                      if (double.tryParse(value) == null ||
                          double.tryParse(value)! > 65535) {
                        return 'Shelf must be under 65535';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownSearch(
                    asyncItems: (String filter) async {
                      final units = await api.fetchUnits();
                      return units;
                    },
                    selectedItem: product['unit'],
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Stock',
                      labelText: 'Stock',
                    ),
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      // if value is above 65536
                      if (int.tryParse(value) == null ||
                          int.tryParse(value)! > 65535) {
                        return 'Shelf must be under 65535';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Shelf',
                      labelText: 'Shelf',
                    ),
                    controller: shelfController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      // if value is above 65536
                      if (int.tryParse(value) == null ||
                          int.tryParse(value)! > 65535) {
                        return 'Shelf must be under 65535';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
                    onPressed: !isFormValid
                        ? null
                        : () async {
                            // add the product to the database
                            final name = nameController.text;
                            final category = categoryController.text;
                            final content =
                                double.tryParse(contentController.text) ?? 0.0;
                            final unit = unitController.text;
                            final location =
                                int.tryParse(locationController.text) ?? 0;
                            final stock =
                                int.tryParse(stockController.text) ?? 0;
                            final shelf =
                                int.tryParse(shelfController.text) ?? 0;

                            final response = await api.updateProduct(
                              id: product['id'],
                              name: name,
                              categoryId: category,
                              content: content,
                              unitId: unit,
                              barcode: product['barcode'].toString(),
                              shelf: shelf,
                              stock: stock,
                              locationId: location,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (response) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User updated successfully'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User update failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }

                            Navigator.of(context).pop();
                          },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
