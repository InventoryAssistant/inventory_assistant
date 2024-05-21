import 'package:dropdown_search/dropdown_search.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:flutter/material.dart';
import 'package:inventory_assistant/modal/add_user_modal.dart';
import 'package:inventory_assistant/modal/edit_user_modal.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/widget/custom_drawer.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final locationController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Admin",
        trailing: IconButton(
          onPressed: () {
            addUserModal(context);
          },
          icon: const Icon(Icons.add),
        ),
        centerTitle: true,
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                locations(),
                if (locationController.text.isNotEmpty)
                  users(locationController.text),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget locations() {
    return DropdownSearch(
      asyncItems: (String filter) async {
        final locations = await api.fetchLocations();
        return locations;
      },
      onChanged: (value) async {
        setState(() {
          locationController.text = value.id.toString();
        });
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Location",
        ),
      ),
      popupProps: const PopupProps.menu(
        fit: FlexFit.loose,
      ),
    );
  }

  Widget users(location) {
    Future<List> userData = api.fetchUsersByLocation(location);
    return FutureBuilder(
      future: userData,
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> users) {
        if (users.hasData) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: users.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Card(
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: StatefulBuilder(builder: (context, setState) {
                          return ExpansionTile(
                            key: GlobalKey(),
                            initiallyExpanded: false,
                            title: Text(
                              "${users.data?[index]['first_name']} ${users.data?[index]['last_name']}",
                              style: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                await editUserModal(
                                  context,
                                  id: users.data?[index]['id'],
                                  firstName: users.data?[index]['first_name'],
                                  lastName: users.data?[index]['last_name'],
                                  location: users.data?[index]['location'],
                                  locationId: users.data?[index]['location_id'],
                                  email: users.data?[index]['email'],
                                  phoneNumber: users.data?[index]
                                      ['phone_number'],
                                  roleId: users.data?[index]['role_id'],
                                  role: users.data?[index]['role'],
                                );

                                final data =
                                    await api.getUser(users.data?[index]['id']);
                                setState(() {
                                  if (data != null) {
                                    users.data?[index] = data;
                                  }
                                });
                              },
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 16, left: 16, right: 16),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Email: ${users.data?[index]['email']}"),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Number: ${users.data?[index]['phone_number']}"),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Location: ${users.data?[index]['location']}"),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        } else if (users.hasError) {
          return Text('${users.error}');
        } else {
          return const Text('');
        }
      },
    );
  }
}
