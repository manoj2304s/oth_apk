import 'package:flutter/material.dart';

class LastScreen extends StatelessWidget {
  const LastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/finish.jpeg"),
        fit: BoxFit.fill,
        // colorFilter: ColorFilter.mode(Colors.black54, BlendMode.dstATop),
      )),
    ));
  }
}
