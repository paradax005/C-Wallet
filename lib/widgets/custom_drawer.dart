import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.wallet,
              color: Colors.blue,
            ),
            title: const Text(
              "My Crypto-currencies",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove("balance");

                Navigator.pushReplacementNamed(context, '/');
              });
            },
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
