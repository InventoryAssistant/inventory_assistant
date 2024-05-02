import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  bool isAdmin = false;
  @override
  void initState() {
    api.isAdmin().then((value) {
      if (value) {
        setState(() {
          isAdmin = true;
        });
      }
    });
    super.initState();
  }

  @override
  build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            ListTile(
              leading: const Icon(
                Icons.camera,
              ),
              title: const Text("Scanner"),
              onTap: () {
                context.goNamed('scanner');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.inventory,
              ),
              title: const Text('Inventory'),
              onTap: () {
                context.goNamed('inventory');
              },
            ),
            if (isAdmin)
              ListTile(
                leading: const Icon(
                  Icons.admin_panel_settings,
                ),
                title: const Text('Admin'),
                onTap: () {
                  context.goNamed('admin');
                },
              ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.person,
              ),
              title: const Text('Profile'),
              onTap: () {
                context.goNamed('profile');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text('Sign Out'),
              onTap: () async {
                // Close Drawer
                Scaffold.of(context).closeDrawer();
                // Call api log out function
                await api.logOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
