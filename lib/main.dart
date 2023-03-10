import 'package:cwallet/screens/detail_screen.dart';
import 'package:cwallet/screens/home_screen.dart';
import 'package:cwallet/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CWallet App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (BuildContext context) {
          return const LoginScreen();
        },
        '/home': (BuildContext context) {
          return const HomeScreen();
        },
        
      },
    );
  }
}
