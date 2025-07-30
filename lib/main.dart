import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/notes/new_notes_view.dart';
import 'package:notes/notes/notes_view.dart';
import 'package:notes/services/crud/note_service.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'dart:developer';
import 'package:notes/services/auth/auth_service.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
      routes: {
        loginroute: (context) => LoginView(),
        regroute: (context) => RegisterView(),
        '/verify/': (context) => VerifyEmail(),
        notesroute: (context) => NotesView(),
        newnotesroute: (constext) => NewNotesView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              log('haha');
              if (user.emailVerified) {
                log('haha2');
                return const NotesView();
              } else {
                log('verify');
                log('haha3');
                return const VerifyEmail();
              }
            } else {
              log('login');
              return const LoginView();
            }
            return const Text('Done');
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuAction { logout }

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('are you sure you want to logout'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
