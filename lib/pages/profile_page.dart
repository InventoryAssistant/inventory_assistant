import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:inventory_assistant/misc/theme.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/widget/custom_drawer.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    user = await api.getCurrentUser();
    setUserData();
  }

  setUserData() {
    firstNameController.text = user['first_name'];
    lastNameController.text = user['last_name'];
    emailController.text = user['email'];
    phoneController.text = user['phone'];
    locationController.text = user['location'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Profile',
      ),
      drawer: const CustomDrawer(),
      body: Row(
        children: [
          const Spacer(),
          Flexible(
            flex: 4,
            child: Column(
              children: [
                const Spacer(),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'First name'),
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Last name'),
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Mail'),
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.words,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Phone number'),
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Password'),
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
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setUserData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            ThemeClass.darkTheme.secondaryHeaderColor,
                        foregroundColor: ThemeClass.darkTheme.primaryColor,
                      ),
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final success = await api.updateUser(
                          userId: user['id'],
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          phoneNumber: phoneController.text,
                          locatioId: locationController.text,
                          password: passwordController.text,
                        );
                        if (success) {
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
                      child: const Text('Update'),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
