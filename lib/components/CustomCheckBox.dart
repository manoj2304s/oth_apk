// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:oth_apk/components/CustomText.dart';
import 'CustomAlert.dart';

class CustomCheckBox extends StatelessWidget {
  final Function callbackFunction;
  final bool isChecked;

  const CustomCheckBox(
      {Key? key, required this.callbackFunction, required this.isChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
                value: isChecked,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (bool? b) => callbackFunction(b)),
          ),
          GestureDetector(
            onTap: () => CustomAlert(
              context: context,
              title: 'Rules and Guidelines',
              subTitle: '''
1. Violation of rules is not entertained.\n
2. Any suspicious activity if found during the course of the event, Science Association reserves all the rights to disqualify the team.\n
3. Science Association is not responsible for the technical issues related to your mobile phone.\n
4. Science Association reserves all the rights to modify/delete any of the above terms and conditions.\n
5. The judgement given by the club is Final.\n\n
Gameplay:\n
1. For every loss of 3 lives, 10 minutes will be added to your game time.\n
2. For use of every hint, 2 minutes will be added.\n
3. Number of logins will be monitored. So make sure you login only once.\n
4. If you completely close the application, you have to restart the game.\n
''',
            ),
            child: Customtext(
                text: 'RULES',
                color: Colors.blue,
                bold: FontWeight.bold,
                size: 18.0,
                decoration: true),
          ),
        ],
      ),
    );
  }
}
