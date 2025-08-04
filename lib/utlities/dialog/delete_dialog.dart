import 'package:flutter/material.dart';
import 'package:notes/utlities/dialog/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete',
    content: 'Are you sure! You want to delete this note?',
    optionBuilder: () => {'Cancel': false, 'Delete': true},
  ).then((value) => value ?? false);
}
