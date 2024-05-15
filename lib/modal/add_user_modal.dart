import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

Future addUserModal(
  BuildContext context, {
  String? firstName,
  String? lastName,
  String? email,
  String? phoneNumber,
  int? locationId,
  int? roleId,
}) async {
  // All of the controllers
  final firstNameController = TextEditingController(text: firstName);
  final lastNameController = TextEditingController(text: lastName);
  final emailController = TextEditingController(text: email);
  final phoneNumberController = TextEditingController(text: phoneNumber);
  final locationIdController =
      TextEditingController(text: locationId?.toString());
  final roleIdController = TextEditingController(text: roleId?.toString());

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Add User'),
          content: Form(
            key: _formKey,
            onChanged: () {
              if (_formKey.currentState!.mounted) {
                setState(() {
                  _isFormValid = _formKey.currentState!.validate();
                });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownSearch(
                  asyncItems: (String filter) async {
                    final locations = await api.fetchLocations();
                    return locations;
                  },
                  onChanged: (value) {
                    locationIdController.text = value.id.toString();
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
                DropdownSearch(
                  asyncItems: (String filter) async {
                    final roles = await api.fetchRoles();
                    return roles;
                  },
                  onChanged: (value) {
                    roleIdController.text = value.id.toString();
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Role",
                    ),
                  ),
                  popupProps: const PopupProps.menu(
                    fit: FlexFit.loose,
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'First Name'),
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Last Name'),
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Phone Number'),
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
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
                  onPressed: !_isFormValid
                      ? null
                      : () async {
                    // add the product to the database
                    final firstName = firstNameController.text;
                    final lastName = lastNameController.text;
                    final locationId = int.parse(locationIdController.text);
                    final roleId = int.parse(roleIdController.text);
                    final email = emailController.text;
                    final phoneNumber = phoneNumberController.text;
                    final password = "test";

                    final response = await api.storeUser(
                      firstName: firstName,
                      lastName: lastName,
                      locationId: locationId,
                      roleId: roleId,
                      email: email,
                      phoneNumber: phoneNumber,
                      password: password,
                    );

                    debugPrint("$response");

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.of(context).pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}
