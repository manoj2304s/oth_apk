import 'package:flutter/material.dart';

Future<bool> onWillPop(BuildContext context) async {
  bool? exitResult = await showDialog(
    context: context,
    builder: (context) => _buildExitDialog(context),
  );
  return exitResult ?? false;
}

Future<bool?> showExitDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (context) => _buildExitDialog(context),
  );
}

AlertDialog _buildExitDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Do you want to exit the app?'),
    content: const Text(
        'All The Game Data Will Be Lost And You Will Be Disqualified!'),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('No'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('Yes'),
      ),
    ],
  );
}
