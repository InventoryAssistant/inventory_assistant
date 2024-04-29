import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late Timer timer;
  String errorMessage = "";
  bool autologin = false;
  bool loginFail = false;
  bool passwordEntered = false;
  bool emailEntered = false;
  bool allPassed = false;

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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "E-mail",
              errorText: loginFail ? errorMessage : null,
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

  _login(email, password) {
    // Uses the API library to login
    api.login(email, password).then((response) {
      Map<String, dynamic> parsed = jsonDecode(response.body);

      if (kDebugMode) {
        debugPrint(response.body);
      }

      // If the response contains an access token and refresh token, the login was successful
      if (parsed['access_token'] != null && parsed['refresh_token'] != null) {
        loginFail = false;

        // Uses API library to store token
        api.storeToken(parsed['access_token']);
        api.storeRefreshToken(parsed['refresh_token']);
        api.storeAutoLogin(autologin);

        // unfocus the textfield
        FocusScope.of(context).unfocus();

        // Navigate to the home screen
        Navigator.pushNamed(context, '/home');
      } else {
        // Clear password, fail login and display error message
        passwordController.clear();
        loginFail = true;
        errorMessage = parsed['message'];

        // unfocus the textfield
        FocusScope.of(context).unfocus();
      }
    }).onError((error, stackTrace) {
      // Clear password, fail login and display error message
      passwordController.clear();
      loginFail = true;
      errorMessage = "Login information is invalid";

      // unfocus the textfield
      FocusScope.of(context).unfocus();
    });
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
