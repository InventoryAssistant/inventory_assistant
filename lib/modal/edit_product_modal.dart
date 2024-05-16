import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:inventory_assistant/misc/extensions/map_extension.dart';

final TextEditingController nameController = TextEditingController();
final TextEditingController categoryController = TextEditingController();
final TextEditingController contentController = TextEditingController();
final TextEditingController unitController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController stockController = TextEditingController();
final TextEditingController shelfController = TextEditingController();
final TextEditingController barcodeController = TextEditingController();
Map<String, dynamic> product = {};
Map<String, dynamic> errors = {};

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
                      return api.fetchLocations();
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }

                      if (errors.containsPartialKey('location')) {
                        return errors[errors.getValue('location')][0];
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a name';
                      }

                      if (errors.containsPartialKey('name')) {
                        return errors[errors.getValue('name')][0];
                      }
                      return null;
                    },
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

                      if (errors.containsPartialKey('barcode')) {
                        return errors[errors.getValue('barcode')][0];
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownSearch(
                    asyncItems: (String filter) async {
                      return api.fetchCategories();
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }

                      if (errors.containsPartialKey('category')) {
                        return errors[errors.getValue('category')][0];
                      }
                      return null;
                    },
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
                        return 'Content must be under 65535';
                      }

                      if (errors.containsPartialKey('content')) {
                        return errors[errors.getValue('content')][0];
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownSearch(
                    asyncItems: (String filter) async {
                      return api.fetchUnits();
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }

                      if (errors.containsPartialKey('unit')) {
                        return errors[errors.getValue('unit')][0];
                      }
                      return null;
                    },
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
                        return 'Stock must be under 65535';
                      }

                      if (errors.containsPartialKey('stock')) {
                        return errors[errors.getValue('stock')][0];
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

                      if (int.tryParse(value) == null ||
                          int.tryParse(value)! > 65535) {
                        return 'Shelf must be under 65535';
                      }

                      if (errors.containsPartialKey('shelf')) {
                        return errors[errors.getValue('shelf')][0];
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

                            final response = api
                                .updateProduct(
                              id: product['id'],
                              name: name,
                              categoryId: category,
                              content: content,
                              unitId: unit,
                              barcode: product['barcode'].toString(),
                              shelf: shelf,
                              stock: stock,
                              locationId: location,
                            )
                                .catchError((error, stackTrace) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$error'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              Navigator.of(context).pop();
                              return {'flutter-error': Future.error(error)};
                            });

                            response.then((value) {
                              if (value.containsKey('errors')) {
                                setState(() {
                                  errors = value['errors'];
                                  formKey.currentState!.validate();
                                });
                                return;
                              }
                              if (value.containsKey('flutter-error')) {
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product updated successfully'),
                                ),
                              );
                              Navigator.of(context).pop();
                            });
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
