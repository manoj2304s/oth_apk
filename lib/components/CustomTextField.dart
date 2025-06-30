// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:oth_apk/components/CustomText.dart';
import '../utilities/constants.dart';

Widget CustomTextField(
    {context,
    text,
    controller,
    placeholder,
    isPassword,
    obscureText,
    keyboardType,
    onPress,
    Icon? icon}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Customtext(
          text: text, color: Colors.white, bold: FontWeight.w500, size: 18.0),
      const SizedBox(height: 10.0),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(93, 134, 133, 133),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: isPassword ? !obscureText : false,
          keyboardType: keyboardType,
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return 'Please enter some text';
          //   }
          //   return null;
          // },
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.only(top: 16.0),
            prefixIcon: icon,
            hintText: placeholder,
            hintStyle: kHintTextStyle,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[200],
                    ),
                    onPressed: () => onPress(),
                  )
                : null,
          ),
        ),
      ),
    ],
  );
}
