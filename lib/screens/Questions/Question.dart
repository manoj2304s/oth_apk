  // ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:get/get.dart';
import 'package:oth_apk/components/CustomAlert.dart';
import 'package:oth_apk/components/CustomText.dart';
import 'package:oth_apk/components/CustomTextField.dart';
import 'package:oth_apk/components/warning_for_closing_app/warning_before_closing.dart';
import 'package:oth_apk/screens/LocationAndQR/location.dart';
import 'package:oth_apk/services/questions/extra_time_counter.dart';
import 'package:oth_apk/services/questions/index_counter.dart';
import 'package:oth_apk/services/questions/location.dart';
import 'package:oth_apk/services/questions/questions.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oth_apk/services/questions/random_num.dart';
import 'package:oth_apk/services/timer/count_player_time.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../components/CustomButton.dart';
import '../../components/CustomSnackbar.dart';
import '../../services/auth/updateUser.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> with WidgetsBindingObserver {
  final IndexCounter c = Get.put(IndexCounter());
  final RandomNumberGenerator randomList = Get.put(RandomNumberGenerator());
  final ExtraTimeCounter extraTime = Get.put(ExtraTimeCounter());
  final LifeCountCounter lifeCount = Get.put(LifeCountCounter());
  final CountPlayerTime time = Get.put(CountPlayerTime());
  final TextEditingController answerController = TextEditingController();
  final store = GetStorage();
  bool takenHint = false;
  var currentLifeCount;
  late int totalQuestionsLength;
  bool isQuestionLoaded = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _restoreTimerFromDatabase();
    getCurrentQuestion();
    time.stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  Future<void> _restoreTimerFromDatabase() async {
    final savedTime = await fetchSavedQuestionTime();
    if (savedTime != null) {
      // Parse savedTime (format: HH:MM:SS) and set timer accordingly
      final parts = savedTime.split(':');
      if (parts.length >= 3) {
        final hours = int.tryParse(parts[0]) ?? 0;
        final minutes = int.tryParse(parts[1]) ?? 0;
        final seconds = int.tryParse(parts[2]) ?? 0;
        final totalMilliseconds =
            ((hours * 3600) + (minutes * 60) + seconds) * 1000;
        time.stopWatchTimer.setPresetTime(mSec: totalMilliseconds);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
    // Get the current timer value
    final value = time.stopWatchTimer.rawTime.value;
    final displayTime = StopWatchTimer.getDisplayTime(value,
      hours: true, minute: true, second: true, milliSecond: false);
    saveQuestionTime(displayTime);
    }
  }
  var sequence = [
    [1, 5, 6, 2, 3, 4, 7, 8, 9],
    [1, 3, 2, 6, 4, 5, 8, 7, 9],
    [1, 4, 3, 2, 6, 7, 8, 5, 9],
    [1, 5, 3, 8, 4, 2, 6, 7, 9],
    [1, 2, 3, 4, 5, 6, 7, 8, 9]
  ];

  var currentQuestionObj;
  var currentSequence;

  Future<dynamic> getCurrentQuestion() async {
    if (kDebugMode) {
      print("In Question Page");
      print(store.read('sequenceNumber') ?? 0);
      print(randomList.randomPicker);
    }

    var sequenceIndex = store.read('sequenceNumber') ?? 0;
    currentSequence = sequence[sequenceIndex];
    var allQuestionsObj = await getAllQuestions();
    totalQuestionsLength = allQuestionsObj.length;
    currentQuestionObj = allQuestionsObj
        .where((item) => item['qid'] == currentSequence[c.curIndex])
        .toList();

    setState(() {
      isQuestionLoaded = true;
    });

    return currentQuestionObj;
  }

  onAnswered() async {
    if (answerController.text.trim().toLowerCase() == '') return;
    if (currentQuestionObj[0]['answer'].toLowerCase() ==
        answerController.text.trim().toLowerCase()) {
      var locationObj;

      await UpdateUsers(field: 'questionId', value: c.curIndex);
      try {
        final value = time.stopWatchTimer.rawTime.value;
        final displayTime = StopWatchTimer.getDisplayTime(value,
            hours: true, minute: true, second: true, milliSecond: false);

        if (kDebugMode) {
          print("TIME-------");
          print(displayTime);
        }
        await UpdateUsers(field: 'questionTime', value: displayTime);
      } catch (err) {
        print(err.toString());
      }

      answerController.clear();
      if (c.curIndex < totalQuestionsLength - 1) {
        locationObj =
            await getLocation(randomList.randomPicker[c.curIndex].toString());
        c.increment();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => LocationPage(
                      correctLat: locationObj != null
                          ? locationObj['coordinates'].latitude
                          : 0.0,
                      correctLong: locationObj != null
                          ? locationObj['coordinates'].longitude
                          : 0.0,
                      code: locationObj != null ? locationObj['code'] : '',
                      isLastQuestion: false,
                    )),
            (Route<dynamic> route) => false);
      } else {
        locationObj = await getLocation("9");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => LocationPage(
                      correctLat: locationObj != null
                          ? locationObj['coordinates'].latitude
                          : 0.0,
                      correctLong: locationObj != null
                          ? locationObj['coordinates'].longitude
                          : 0.0,
                      code: locationObj != null ? locationObj['code'] : '',
                      isLastQuestion: true,
                    )),
            (Route<dynamic> route) => true);

        if (kDebugMode) {
          print("Completed ALl THe Questions");
        }
      }
    } else {
      // HapticFeedback.heavyImpact();
      Vibrate.vibrate();

      String question = currentQuestionObj[0]['question'];
      String hint = currentQuestionObj[0]['hint'];
      
      lifeCount.setCurrentQuestion(question, hint);
      lifeCount.removeLife();
      
      if (lifeCount.lifeCount == 0) {
        CustomAlert(
            title: "Restoring Life",
            subTitle:
                "All Lives Lost! Timeout Initiated!",
            context: context);
        // Only trigger timeout when all lives are lost
        lifeCount.restoreLife();
      } else {
        // Show remaining lives message
        CustomAlert(
            title: "Wrong Answer",
            subTitle:
                "Lives Remaining: ${lifeCount.lifeCount}",
            context: context);
      }
      setState(() {
        currentLifeCount = lifeCount.lifeCount;
      });

      CustomSnackbarWithoutAction(
          context: context, text: 'Wrong Answer! 1 Minute Timeout.');

      if (kDebugMode) {
        print("Life Count : " + lifeCount.lifeCount.toString());
      }
    }
  }

  onHintPressed() {
    extraTime.handleHintTimeout(
      currentQuestionObj[0]['question'],
      currentQuestionObj[0]['hint']
    );
    takenHint = true;
  }

  @override
  Widget build(BuildContext context) {
    currentLifeCount = lifeCount.lifeCount;
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: StreamBuilder(
        stream: time.stopWatchTimer.rawTime,
        initialData: time.stopWatchTimer.rawTime.value,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
      final value = snapshot.data!;
      final displayTime = StopWatchTimer.getDisplayTime(value,
        hours: true, milliSecond: false);

          return Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                for (var i = 0; i < currentLifeCount; i++)
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                const SizedBox(
                  width: 5,
                ),
                IconButton(
                  onPressed: onHintPressed,
                  icon: const Icon(
                    Icons.lightbulb,
                    color: Colors.yellowAccent,
                  ),
                )
              ],
              title: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 20, 12, 8),
                child: Text(
                  displayTime.toString(),
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: Color.fromARGB(255, 192, 192, 192),
                      fontSize: 28,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600),
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
                child: isQuestionLoaded
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                margin: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Customtext(
                                        text: currentQuestionObj[0]['question'],
                                        size: 22.0,
                                        color: Color.fromARGB(255, 192, 192, 192),
                                        bold: FontWeight.w500),
                                  ),
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: CustomTextField(
                                context: context,
                                text: "Answer",
                                controller: answerController,
                                placeholder: "Enter your answer here",
                                isPassword: false,
                                keyboardType: TextInputType.text,
                                icon: const Icon(Icons.question_answer,
                                    color: Colors.white),
                                onPress: () {}),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          CustomButtom(
                              context: context,
                              gradiant: true,
                              onPress: onAnswered,
                              textColor: Colors.white,
                              buttonText: 'SUBMIT')
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 60, 30, 1),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
