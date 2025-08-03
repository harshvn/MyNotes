// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/utlities/dialog/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _pass;

  @override
  void initState() {
    _email = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter your email"),
          ),
          TextField(
            controller: _pass,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: "Enter your password"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _pass.text;
              try {
                final userCredential = await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified) {
                    log(user.emailVerified.toString());
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(notesroute, (route) => false);
                  } else {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/verify/', (route) => false);
                  }
                } else {
                  await showErrorDialog(context, 'Enter Email ID');
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  log(e.toString());
                  await showErrorDialog(context, 'User not found');
                } else if (e.code == 'wrong-password') {
                  log(e.toString());
                  await showErrorDialog(context, 'Wrong Password');
                } else {
                  await showErrorDialog(context, e.code.toString());
                }
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil(regroute, (route) => false);
            },
            child: Text("Not Registered yet? Register here"),
          ),
        ],
      ),
    );
  }
}
