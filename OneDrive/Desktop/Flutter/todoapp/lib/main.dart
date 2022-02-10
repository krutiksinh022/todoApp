import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/auth/authform.dart';
import 'package:todoapp/auth/authscreen.dart';
import 'package:todoapp/screnns/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
            ThemeData(brightness: Brightness.dark, primaryColor: Colors.purple),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, usersnapShot) {
            if (usersnapShot.hasData) {
              return HomePage();
            } else {
              return AuthScreen();
            }
          },
        ));
  }
}
