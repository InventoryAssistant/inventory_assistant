import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/theme.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController locationController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
Map<String, dynamic> user = {};

setUserData(Map<String, dynamic> user) {
  firstNameController.text = user['first_name'];
  lastNameController.text = user['last_name'];
  emailController.text = user['email'];
  phoneController.text = user['phone'];
  locationController.text = user['location_id'].toString();
  passwordController.text = '';
}

Future editProfileModal(
  BuildContext context, {
  required Map<String, dynamic> user,
}) {
  setUserData(user);
  // Create a global key for the form
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            scrollable: true,
            title: const Text('Edit profile'),
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
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'First name',
                      labelText: 'First name',
                      errorStyle: TextStyle(
                        fontSize: 0,
                      ),
                    ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Last name',
                      labelText: 'Last name',
                      errorStyle: TextStyle(
                        fontSize: 0,
                      ),
                    ),
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
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Mail',
                      labelText: 'Mail',
                      errorStyle: TextStyle(
                        fontSize: 0,
                      ),
                    ),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Phone number',
                      labelText: 'Phone number',
                      errorStyle: TextStyle(
                        fontSize: 0,
                      ),
                    ),
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                    ),
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setUserData(user);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ThemeClass.darkTheme.secondaryHeaderColor,
                      foregroundColor: ThemeClass.darkTheme.primaryColor,
                    ),
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: !_isFormValid
                        ? null
                        : () async {
                            final password = passwordController.text.isEmpty
                                ? null
                                : passwordController.text;
                            final response = await api.updateUser(
                              userId: user['id'],
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              phoneNumber: phoneController.text,
                              locatioId: int.parse(locationController.text),
                              password: password,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            if (response) {
                              debugPrint('User updated successfully');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User updated successfully'),
                                ),
                              );
                            } else {
                              debugPrint('User update failed');
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
