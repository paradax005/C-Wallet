import 'package:cwallet/utils/config.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    usernameController.text = "wiem";
    idController.text = "1458";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.clear();
    idController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _keyForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Image.asset(
                    "assets/LOGO.png",
                    width: 300,
                    height: 200,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your username";
                    }
                    return null;
                  },
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("Username"),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please enter your ID";
                    }
                    return null;
                  },
                  controller: idController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text("ID"),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        loginUser(context, usernameController.text,
                            idController.text);
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(
      BuildContext context, String username, String id) async {
    Map<String, String> userData = {"username": username, "identifier": id};

    Map<String, String> headers = {
      "Content-Type": "application/json; charset=UTF-8"
    };

    http
        .post(Uri.http(Config.baseUrl, "/api/users/login/id"),
            headers: headers, body: json.encode(userData))
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        Map<String, dynamic> userResponse = json.decode(response.body);

        SharedPreferences.getInstance().then((prefs) {
          prefs.setDouble("balance", userResponse['balance'].toDouble());
          prefs.setString("userid", userResponse['_id']);

          Navigator.pushReplacementNamed(context, "/home");
        });
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Error"),
              content: Text(
                "Username or ID are incorrect",
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Information"),
              content: Text(
                "An error has occurred, please try again later!",
              ),
            );
          },
        );
      }
    });
  }
}
