// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

CircularLoader(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
      children: [
        const CircularProgressIndicator(color: Color.fromARGB(255, 60, 30, 1),),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: const Text("Loading..."),
        ),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
