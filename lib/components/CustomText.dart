// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

Widget Customtext(
    {text, color, bold, size, bool decoration = false, dynamic letterspacing, bool textCenter = false}) {
  return Text(
    text,
    textAlign: textCenter ? TextAlign.center : TextAlign.start,
    style: TextStyle( 
      color: color,
      fontSize: size,
      fontWeight: bold,
      fontFamily: 'OpenSans',
      letterSpacing: letterspacing ?? 0,
      decoration: decoration ? TextDecoration.underline : TextDecoration.none,
      decorationColor: decoration ? Colors.blue[400] : Colors.transparent,
    ),
  );
}
