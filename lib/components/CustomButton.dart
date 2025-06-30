// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

import 'CustomText.dart';

Widget CustomButtom({
  required BuildContext context,
  required Function onPress,
  required String buttonText,
  bool? gradiant,
  TextStyle? textStyle,
  Color? textColor
}) {
  gradiant = gradiant ?? false;
  return GestureDetector(
    onTap: () {
      onPress();
    },
    child: Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 45,
      decoration: BoxDecoration(
        gradient: gradiant
            ? const LinearGradient(colors: [
                Color.fromRGBO(120, 14, 1, 0.8),
                Color.fromRGBO(52, 8, 4, 0.8)
              ])
            : null,
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Center(
        child: Customtext(
            text: buttonText,
            color: textColor,
            bold: FontWeight.w900,
            letterspacing: 3.0,
            size: 18.0),
      ),
    ),
  );
}
