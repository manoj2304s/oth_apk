// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:oth_apk/components/CustomButton.dart';
import 'package:oth_apk/screens/Otp/Otp.dart';
import '../../components/CircularProgress.dart';
import '../../components/CustomCheckBox.dart';
import '../../components/CustomSnackbar.dart';
import '../../components/CustomTextField.dart';
import 'package:get/get.dart';
import '../../services/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  bool isPasswordVisible = false;
  var alertDialogContext;

  @override
  void initState() {
    setState(() {
      alertDialogContext = context;
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginButtonPress() async {
    if (emailController.text.trim().isEmpty) {
      CustomSnackbarWithoutAction(context: context, text: 'Email is required');
    } else if (passwordController.text.trim().isEmpty) {
      CustomSnackbarWithoutAction(
          context: context, text: 'Password is required');
    } else if (!isChecked) {
      CustomSnackbarWithoutAction(
          context: context, text: 'Please accept terms and conditions');
    } else {
      CircularLoader(alertDialogContext);

      dynamic signinRsponse = await signInwithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      if (signinRsponse == 'user-not-found') {
        Navigator.of(alertDialogContext).pop();
        CustomSnackbarWithoutAction(
            context: context, text: 'No user found with the email');
      } else if (signinRsponse == 'wrong-password') {
        Navigator.of(alertDialogContext).pop();
        passwordController.clear();
        CustomSnackbarWithoutAction(
            context: context, text: 'Incorrect email/password');
      } else if (signinRsponse == 'error') {
        Navigator.of(alertDialogContext).pop();
        CustomSnackbarWithoutAction(
            context: context, text: 'Error! Please try again.');
      } else if (signinRsponse == 'loggedIn') {
        getTotalUsersLength();
        Navigator.of(alertDialogContext).pop();
        Get.to(const Otp());
      }
    }
  }

  callback(valIsChecked) {
    setState(() {
      isChecked = valIsChecked;
    });
  }

  passwordVisiblecallback() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 41, 41, 42),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  colorFilter:
                      ColorFilter.mode(Colors.black87, BlendMode.dstATop),
                  image: AssetImage(
                    'assets/images/bg1.jpeg',
                  )),
            ),
          ),
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Online Treasure Hunt',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    ' ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 28.0,
                      height: 2.0,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  CustomTextField(
                      context: context,
                      text: "Email",
                      controller: emailController,
                      placeholder: "Enter email",
                      isPassword: false,
                      keyboardType: TextInputType.emailAddress,
                      icon:
                          const Icon(Icons.email_rounded, color: Colors.white),
                      onPress: () {}),
                  const SizedBox(height: 30.0),
                  CustomTextField(
                      context: context,
                      text: "Password",
                      controller: passwordController,
                      placeholder: "Enter password",
                      isPassword: true,
                      obscureText: isPasswordVisible,
                      keyboardType: TextInputType.text,
                      icon: const Icon(Icons.lock_outline_rounded,
                          color: Colors.white),
                      onPress: passwordVisiblecallback),
                  const SizedBox(height: 30.0),
                  CustomCheckBox(
                      callbackFunction: callback, isChecked: isChecked),
                  const SizedBox(height: 30.0),
                  CustomButtom(
                      context: context,
                      onPress: loginButtonPress,
                      buttonText: 'Login')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
