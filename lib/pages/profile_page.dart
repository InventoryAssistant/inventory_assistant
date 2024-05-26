import 'package:flutter/material.dart';
import 'package:inventory_assistant/modal/edit_profile_modal.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/widget/custom_drawer.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> user = {};

  Future<Map<String, dynamic>> getUserData() async {
    user = await api.getCurrentUser();
    return user;
  }

  updateData() {
    getUserData().then((data) {
      setState(() {
        user = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        trailing: IconButton(
          onPressed: () async {
            await editProfileModal(context, user: user);
            updateData();
          },
          icon: const Icon(Icons.edit),
        ),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder(
        future: getUserData(),
        builder:
            (BuildContext context, AsyncSnapshot<Map<String, dynamic>> data) {
          if (data.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final Map<String, dynamic> user = data.data ?? {};
          return Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  '${user['first_name']} ${user['last_name']}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email: ${user['email']}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Phone: ${user['phone']}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Location: ${user['location']}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
