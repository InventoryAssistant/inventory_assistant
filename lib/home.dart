import 'package:flutter/material.dart';
import 'package:inventory_assistant/widget/custom_appbar.dart';
import 'package:inventory_assistant/widget/custom_drawer.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'inventory page',
      ),
      drawer: const CustomDrawer(),
      body: SizedBox(
        child: Row(
          children: [
            const Spacer(),
            Flexible(
              child: Column(
                children: [
                  const Spacer(),
                  const Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Welcome to the home screen",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            api.logOut();
                          },
                          child: const Text("Go to Login Screen"),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
