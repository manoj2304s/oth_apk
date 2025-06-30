// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oth_apk/screens/Story/Story.dart';

import '../../components/CustomButton.dart';
import '../../components/CustomSnackbar.dart';
import '../../services/auth/updateUser.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _gamepin = "2304";
  var enteredPin = '';

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromRGBO(120, 14, 1, 0.9),
          Color.fromRGBO(52, 8, 4, 0.9)
        ])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                const SizedBox(
                  height: 120,
                ),
                const Text(
                  'Verification',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter The Game Code",
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    // border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _textFieldOTP(
                              first: true,
                              last: false,
                              controller: _otpController),
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: _otpController2),
                          _textFieldOTP(
                              first: false,
                              last: false,
                              controller: _otpController3),
                          _textFieldOTP(
                              first: false,
                              last: true,
                              controller: _otpController4),
                        ],
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: CustomButtom(
                          context: context,
                          onPress: otpButtonPress,
                          buttonText: "Enter",
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void otpButtonPress() {
    FocusScope.of(context).unfocus();

    enteredPin = _otpController.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text;

    if (kDebugMode) {
      print(enteredPin);
    }

    if (_gamepin == enteredPin) {
      UpdateUsers(field: 'loginCount', value: FieldValue.increment(1))
          .then((value) => {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Story()))
              })
          // ignore: invalid_return_type_for_catch_error
          .catchError((onError) => {
                CustomSnackbarWithoutAction(
                    context: context,
                    text: 'Something went wrong. Please try again')
              });
    } else {
      CustomSnackbarWithoutAction(
          context: context,
          text: 'Entered Wrong Pin!\nPlease Collect Correct Game Pin.');
    }
  }

  Widget _textFieldOTP({bool? first, last, controller}) {
    return SizedBox(
      height: 60,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(2),
            fillColor: Colors.white,
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.black54),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 3, color: Color.fromARGB(225, 255, 1, 1)),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
