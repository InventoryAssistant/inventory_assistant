import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

// All of the controllers
final passwordController = TextEditingController();
Map<String, dynamic> user = {};

Future changePasswordModal(
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

  Map<String, dynamic> errors = {
    'password': '',
  };

  final formKey = GlobalKey<FormState>();

  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Please change password'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                    if (value == null || value == "") {
                      return "Please enter a password";
                    }

                    if (errors['password'] != null &&
                        errors['password'] != '') {
                      return errors['password'];
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Confirm Password', errorMaxLines: 2),
                  obscureText: true,
                  onChanged: (_) {
                    setState(() {
                      errors['password'] = '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please confirm your password";
                    }

                    if (passwordController.text != value) {
                      return 'Passwords do not match';
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
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final password = passwordController.text;

                      await api
                          .updateUser(
                        userId: user['id'],
                        firstName: user['first_name'],
                        lastName: user['last_name'],
                        locationId: user['location_id'],
                        roleId: user['role_id'],
                        email: user['email'],
                        phoneNumber: user['phone_number'],
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
                              content: Text('Password updated successfully.'),
                            ),
                          );
                          context.pushNamed('scanner');
                        } else if (response.containsKey('errors')) {
                          setState(() {
                            errors['password'] =
                                response['errors']['password']?[0] ?? '';
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
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ],
        );
      });
    },
  );
}
