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

udpateUserModal(
  BuildContext context, {
  required Map<String, dynamic> user,
}) {
  setUserData(user);

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: const Text('Edit profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'First name',
                labelText: 'First name',
              ),
              controller: firstNameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Last name',
                labelText: 'Last name',
              ),
              controller: lastNameController,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Mail',
                labelText: 'Mail',
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.words,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Phone number',
                labelText: 'Phone number',
              ),
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password',
              ),
              controller: passwordController,
              obscureText: true,
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
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setUserData(user);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeClass.darkTheme.secondaryHeaderColor,
                  foregroundColor: ThemeClass.darkTheme.primaryColor,
                ),
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: () {
                  final password = passwordController.text.isEmpty
                      ? null
                      : passwordController.text;
                  final success = api.updateUser(
                    userId: user['id'],
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    phoneNumber: phoneController.text,
                    locatioId: int.parse(locationController.text),
                    password: password,
                  );

                  success.then(
                    (value) {
                      if (value) {
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
                    },
                  );
                },
                child: const Text('Update'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
