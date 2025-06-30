// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
    CustomSnackbarWithoutAction({context, required String text}) {
  final snackBar = SnackBar(content: Text(text));

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
    CustomSnackbarWithAction(
        {context,
        required String text,
        required String actionLabel,
        required Function onActionPress}) {
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: actionLabel,
      onPressed: () {
        onActionPress();
      },
    ),
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
