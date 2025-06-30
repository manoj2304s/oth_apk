// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Color.fromARGB(255, 231, 225, 225),
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  fontSize: 18,
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final termsStyle = TextStyle(
  fontSize: 18,
  color: Colors.blue[400],
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  decoration: TextDecoration.underline,
  decorationColor: Colors.blue[400]
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: const [
    BoxShadow(
      color: Colors.black,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);