// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:oth_apk/components/CustomButton.dart';
import 'package:oth_apk/screens/Questions/Question.dart';
import 'package:oth_apk/services/story/story.dart';

class Story extends StatelessWidget {
  const Story({Key? key}) : super(key: key);

  static const story = '''
You are an ardent RCB fan, and you’ve been selected as a part of their “Fan Intelligence Unit” to solve a mystery. \n
 RCB’s secret strategy book, containing plans for the upcoming IPL season, has gone missing! /n
 The clues to its whereabouts are hidden in scanners scattered across the campus. \n
 Each scanner unlocks the next step in your mission. Only the most loyal and intelligent fans can crack the riddles and save RCB!''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(12.0, 20, 12, 8),
          child: Text(
            'GAME STORY...',
            style: TextStyle(
                decoration: TextDecoration.none,
                color: Color.fromARGB(255, 192, 192, 192),
                fontSize: 28,
                letterSpacing: 2,
                fontWeight: FontWeight.w900),
          ),
        ),
        titleSpacing: 4,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/screen3.jpg"),
          fit: BoxFit.fill,
        )),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  // FutureBuilder(
                  //   future: getStory(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.waiting) {
                  //       return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 60, 30, 1),));
                  //     } else {
                  //       if (snapshot.hasError) {
                  //         var error = snapshot.error;
                  //         return Center(
                  //             child: Text('Error: $error',
                  //                 style: const TextStyle(fontSize: 30)));
                  //       } else {
                  //         return Column(
                  //           children: [
                  //             Center(
                  //                 child: Text('${snapshot.data}',
                  //                     overflow: TextOverflow.clip,
                  //                     style: const TextStyle(
                  //                         fontSize: 26,
                  //                         fontWeight: FontWeight.w500))),
                  //             CustomButtom(
                  //                 context: context,
                  //                 gradiant: true,
                  //                 textColor: Colors.white,
                  //                 onPress: () => {
                  //                       Navigator.of(context).pushReplacement(
                  //                           MaterialPageRoute(
                  //                               builder: (context) =>
                  //                                   const Question()))
                  //                     },
                  //                 buttonText: 'Start Loot!')
                  //           ],
                  //         );
                  //       }
                  //     }
                  //   },
                  // ),
                  const Center(
                    child: Text(
                      story,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 192, 192, 192),
                      ),
                    ),
                  ),
                  CustomButtom(
                      context: context,
                      gradiant: true,
                      textColor: Color.fromARGB(255, 192, 192, 192),
                      onPress: () => {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Question()))
                          },
                      buttonText: 'Start Loot!')
                ],
              ),
            ),
          ),
        ),
      ),
      // body: SafeArea(
      //   child: Stack(
      //     children: [
      //       Container(
      //         decoration: const BoxDecoration(
      //           image: DecorationImage(
      //             image: AssetImage("assets/images/background.jpeg"),
      //             fit: BoxFit.fill,
      //             colorFilter:
      //                 ColorFilter.mode(Colors.black54, BlendMode.dstATop),
      //           ),
      //         ),
      //       ),
      //       SingleChildScrollView(
      //         child: Padding(
      //           padding: const EdgeInsets.all(14.0),
      //           // child: Text(
      //           //     "Lorem Ipsum is simply dummy te.",
      //           //     style: TextStyle(fontSize: 30),
      //           //   ),
      //           child: Column(
      //             children: [
      //               FutureBuilder(
      //                 future: getStory(),
      //                 builder: (context, snapshot) {
      //                   if (snapshot.connectionState ==
      //                       ConnectionState.waiting) {
      //                     return const Center(
      //                         child: CircularProgressIndicator());
      //                   } else {
      //                     if (snapshot.hasError) {
      //                       var error = snapshot.error;
      //                       return Center(
      //                           child: Text('Error: $error',
      //                               style: const TextStyle(fontSize: 30)));
      //                     } else {
      //                       return Center(
      //                           child: Text('${snapshot.data}',
      //                               style: const TextStyle(fontSize: 30)));
      //                     }
      //                   }
      //                 },
      //               ),
      //               CustomButtom(
      //                   context: context,
      //                   onPress: () => {
      //                         Navigator.of(context).pushReplacement(
      //                             MaterialPageRoute(
      //                                 builder: (context) => const Question()))
      //                       },
      //                   buttonText: 'Start Loot!')
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
