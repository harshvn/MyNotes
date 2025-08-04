import 'package:flutter/material.dart';
import 'package:notes/utlities/dialog/generic_dialog.dart';

Future<void> showcannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'sharing',
    content: 'Cannot share empty note',
    optionBuilder: () => {'OK': null},
  );
}
