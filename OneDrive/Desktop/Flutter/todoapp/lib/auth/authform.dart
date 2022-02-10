//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _userName = '';
  bool isLoadingpage = false;
  startAuthentications() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _userName);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    AuthResult authResult;
    try {
      if (isLoadingpage) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user.uid;
        await Firestore.instance
            .collection('user')
            .document(uid)
            .setData({'username': username, 'password': password});
      }
    } catch (err) {
      print(err);
    }
  }

  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!isLoadingpage)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey("username"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please Enter UserName";
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _userName = value!;
                        },
                        decoration:
                            InputDecoration(labelText: "Enter  UserName"),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey("email"),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains("@")) {
                          return "please Enter valid email";
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      decoration:
                          InputDecoration(labelText: "Enter your Email"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey("password"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please Enter password";
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      decoration:
                          InputDecoration(labelText: "Enter your Password"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        startAuthentications();
                      },
                      child: Container(
                        color: Colors.purple,
                        height: 40,
                        width: 200,
                        child: Center(
                            child: isLoadingpage
                                ? Text("Log In")
                                : Text(
                                    "Sign UP",
                                  )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isLoadingpage = !isLoadingpage;
                        });
                      },
                      child: Container(
                        child: isLoadingpage
                            ? Center(child: Text("Not a members"))
                            : Text("Alredy Memeber?"),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
