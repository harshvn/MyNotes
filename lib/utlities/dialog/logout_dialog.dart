import 'package:flutter/material.dart';
import 'package:notes/utlities/dialog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure! You want to logout?',
    optionBuilder: () => {'Cancel': false, 'Log Out': true},
  ).then((value) => value ?? false);
}
