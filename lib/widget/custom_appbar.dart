import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.title = 'Inventory Assistant'});
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
        ),
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }
}
