import 'package:flutter/material.dart';

Future addProductModal(BuildContext context, {name, category, amount}) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Product'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: 'Name'),
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Category'),
            ),
            TextField(
              decoration: InputDecoration(hintText: 'Amount'),
              keyboardType: TextInputType.number,
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
