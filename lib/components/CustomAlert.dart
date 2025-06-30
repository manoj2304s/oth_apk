// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

Future<void> CustomAlert(
    {context, required String title, required String subTitle}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(subTitle)),
        actions: <Widget>[
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
