import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_assistant/misc/api/api_lib.dart' as api;
import 'package:inventory_assistant/modal/change_password_modal.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
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
      final currentUser = await api.getCurrentUser();

      if (currentUser['id'] != 0 &&
          currentUser['first_login'] != null &&
          currentUser['first_login']) {
        changePasswordModal(
          context,
          id: currentUser['id'],
          firstName: currentUser['first_name'],
          lastName: currentUser['last_name'],
          email: currentUser['email'],
          phoneNumber: currentUser['phone'],
          location: currentUser['location'],
          locationId: currentUser['location_id'],
          role: currentUser['role'],
          roleId: currentUser['role_id'],
        );
      } else {
        _goHome();
      }
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
    context.pushNamed("scanner");
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
