import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Map<String, dynamic> errors = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'phone_number': '',
    'location': '',
    'role': '',
  };

  final formKey = GlobalKey<FormState>();

  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Add User'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                DropdownSearch(
                  asyncItems: (String filter) async {
                    return await api.fetchLocations();
                  },
                  onChanged: (value) {
                    setState(() {
                      locationIdController.text = value.id.toString();
                      errors['location'] = '';
                    });
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Location",
                      errorMaxLines: 2,
                    ),
                  ),
                  popupProps: const PopupProps.menu(
                    fit: FlexFit.loose,
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please choose a location";
                    }

                    if (errors['location'] != null &&
                        errors['location'] != '') {
                      return errors['location'];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                DropdownSearch(
                  asyncItems: (String filter) async {
                    return await api.fetchRoles();
                  },
                  onChanged: (value) {
                    setState(() {
                      roleIdController.text = value.id.toString();
                      errors['role'] = '';
                    });
                  },
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Role",
                      errorMaxLines: 2,
                    ),
                  ),
                  popupProps: const PopupProps.menu(
                    fit: FlexFit.loose,
                  ),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please choose a role";
                    }

                    if (errors['role'] != null && errors['role'] != '') {
                      return errors['role'];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'First Name', errorMaxLines: 2),
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) {
                    setState(() {
                      errors['first_name'] = '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter a first name";
                    }

                    if (errors['first_name'] != null &&
                        errors['first_name'] != '') {
                      return errors['first_name'];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Last Name', errorMaxLines: 2),
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) {
                    setState(() {
                      errors['last_name'] = '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter a last name";
                    }

                    if (errors['last_name'] != null &&
                        errors['last_name'] != '') {
                      return errors['last_name'];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Email', errorMaxLines: 2),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) {
                    setState(() {
                      errors['email'] = '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter an email";
                    }

                    if (errors['email'] != null && errors['email'] != '') {
                      return errors['email'];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Phone Number', errorMaxLines: 2),
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  onChanged: (_) {
                    setState(() {
                      errors['phone_number'] = '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter a phone number";
                    }

                    if (errors['phone_number'] != null &&
                        errors['phone_number'] != '') {
                      return errors['phone_number'];
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
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // add the product to the database
                      final firstName = firstNameController.text;
                      final lastName = lastNameController.text;
                      final locationId = int.parse(locationIdController.text);
                      final roleId = int.parse(roleIdController.text);
                      final email = emailController.text;
                      final phoneNumber = phoneNumberController.text;
                      final password = getRandomString(20);

                      await api
                          .storeUser(
                        firstName: firstName,
                        lastName: lastName,
                        locationId: locationId,
                        roleId: roleId,
                        email: email,
                        phoneNumber: phoneNumber,
                        password: password,
                      )
                          .catchError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            dismissDirection: DismissDirection.none,
                            content: Text('$error'),
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                          ),
                        );
                        Navigator.of(context).pop();
                        return error;
                      }).then((response) {
                        if (response['status'] == 201) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              dismissDirection: DismissDirection.none,
                              content: Text(
                                  '$firstName $lastName added with password: $password'),
                              showCloseIcon: true,
                              duration: const Duration(days: 365),
                              action: SnackBarAction(
                                onPressed: () async {
                                  await Clipboard.setData(
                                      ClipboardData(text: password));
                                },
                                label: 'Copy',
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        } else if (response.containsKey('errors')) {
                          setState(() {
                            errors['first_name'] =
                                response['errors']['first_name']?[0] ?? '';
                            errors['last_name'] =
                                response['errors']['last_name']?[0] ?? '';
                            errors['email'] =
                                response['errors']['email']?[0] ?? '';
                            errors['phone_number'] =
                                response['errors']['phone_number']?[0] ?? '';
                            errors['role'] =
                                response['errors']['role']?[0] ?? '';
                            errors['location'] =
                                response['errors']['location']?[0] ?? '';
                            formKey.currentState!.validate();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              dismissDirection: DismissDirection.none,
                              content: Text(
                                  '${response.containsKey('message') ? response['message'] : response}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      });
                    }
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
