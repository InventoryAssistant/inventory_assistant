import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  late Timer timer;
  bool autologin = false;
  bool loginFail = false;
  bool passwordEntered = false;
  bool emailEntered = false;
  bool allPassed = false;

  @override
  void initState() {
    debugPrint("Login screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(),
          const Text(
            "Login",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          OrientationBuilder(
            builder: (context, orientation) {
              return MediaQuery.of(context).size.width < 600
                  ? verticalDesign()
                  : horizontalDesign();
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget verticalDesign() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: loginUI(),
    );
  }

  Widget horizontalDesign() {
    return Row(
      children: [
        const Spacer(),
        Flexible(
          child: loginUI(),
        ),
        const Spacer(),
      ],
    );
  }

  Widget loginUI() {
    return Column(
      children: [
        TextField(
            focusNode: emailFocusNode,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "E-mail",
              errorText: loginFail ? 'Login information is invalid' : null,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[400]!,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
            ),
            onChanged: (value) {
              setState(() {
                emailEntered = value.isNotEmpty ? true : false;
              });
              checkIfAllGood();
            }),
        const SizedBox(
          height: 20,
        ),
        TextField(
            focusNode: passwordFocusNode,
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Password",
              errorText: loginFail ? 'Login information is invalid' : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[400]!,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
            ),
            onChanged: (value) {
              setState(() {
                passwordEntered = value.isNotEmpty ? true : false;
              });
              checkIfAllGood();
            }),
        CheckboxListTile(
          title: const Text("Stay logged in?"),
          value: autologin,
          onChanged: (value) {
            setState(() {
              autologin = value!;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: allPassed ? Colors.black : Colors.grey[400]!,
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: allPassed
                    ? () async {
                        _login(
                          emailController.text,
                          passwordController.text,
                        );
                      }
                    : null,
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _login(email, password) async {
    // Uses the API library to login
    final bool loggedin = await api.login(email, password, autologin);

    // If the log in was a success then navigate to the home screen
    if (loggedin) {
      setState(() {
        loginFail = false;
      });

      // unfocus the textfield
      emailFocusNode.unfocus();
      passwordFocusNode.unfocus();

      // Navigate to the home screen
      debugPrint("Login successful");
      context.goNamed("home");
      // _goHome();
    } else {
      // Clear password, fail login and display error message
      passwordController.clear();

      // Fail the login to get error message
      setState(() {
        loginFail = true;
      });

      // unfocus the textfield
      emailFocusNode.unfocus();
      passwordFocusNode.unfocus();
    }
  }

  void _goHome() {
    debugPrint("Navigating to home screen");
    context.goNamed("home");
  }

  checkIfAllGood() {
    if (passwordEntered && emailEntered) {
      setState(() {
        allPassed = true;
      });
    } else {
      setState(() {
        allPassed = false;
      });
    }
  }
}
