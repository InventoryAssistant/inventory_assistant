import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

// All of the controllers
final firstNameController = TextEditingController();
final lastNameController = TextEditingController();
final emailController = TextEditingController();
final phoneNumberController = TextEditingController();
final locationIdController = TextEditingController();
final roleIdController = TextEditingController();
final passwordController = TextEditingController();
Map<String, dynamic> user = {};

/// Set the user data
_setUserData(Map<String, dynamic> data) {
  firstNameController.text = data['first_name'];
  lastNameController.text = data['last_name'];
  emailController.text = data['email'];
  phoneNumberController.text = data['phone_number'];
  locationIdController.text = data['location_id'].toString();
  roleIdController.text = data['role_id'].toString();
  passwordController.text = '';
}

Future editUserModal(
  BuildContext context, {
  required int id,
  required String firstName,
  required String lastName,
  required String email,
  required String phoneNumber,
  required String location,
  required String role,
  required int locationId,
  required int roleId,
}) async {
  user = {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'location_id': locationId,
    'location': location,
    'role': role,
    'role_id': roleId,
    'password': '',
  };
  _setUserData(user);

  Map<String, dynamic> errors = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'phone_number': '',
    'location': '',
    'role': '',
  };

  final formKey = GlobalKey<FormState>();

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Edit User'),
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
                  selectedItem: user['location'],
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
                  selectedItem: user['role'],
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
                      hintText: 'First Name',
                      labelText: 'First Name',
                      errorMaxLines: 2),
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
                      hintText: 'Last Name',
                      labelText: 'Last Name',
                      errorMaxLines: 2),
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
                      hintText: 'Email', labelText: 'Email', errorMaxLines: 2),
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
                      hintText: 'Phone Number',
                      labelText: 'Phone Number',
                      errorMaxLines: 2),
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
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Password', errorMaxLines: 2),
                  controller: passwordController,
                  obscureText: true,
                  onChanged: (_) {
                    setState(() {
                      errors['password'] = '';
                    });
                  },
                  validator: (value) {
                    if (errors['password'] != null &&
                        errors['password'] != '') {
                      return errors['password'];
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
                    _setUserData(user);
                  },
                  child: const Text('Reset'),
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

                      final password = passwordController.text.isEmpty
                          ? null
                          : passwordController.text;

                      await api
                          .updateUser(
                        userId: user['id'],
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
                        if (response['status'] == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              dismissDirection: DismissDirection.none,
                              content: Text('User updated successfully.'),
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
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}
