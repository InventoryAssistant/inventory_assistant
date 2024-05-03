import 'package:flutter/material.dart';

Future addProductModal(
  BuildContext context, {
  String? name,
  String? category,
  double? content,
  String? unit,
}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(hintText: 'Name'),
              initialValue: name,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Category'),
              initialValue: category,
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Content'),
              initialValue: content?.toString(),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: 'Unit'),
              initialValue: unit,
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
                onPressed: () {
                  // add the product to the database
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
