import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oth_apk/screens/Timeout/timeout_screen.dart';
import 'package:oth_apk/services/timer/count_player_time.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ExtraTimeCounter extends GetxController {
  final CountPlayerTime time = Get.put(CountPlayerTime());

  static const int HINT_TIMEOUT_SECONDS = 180; // 3 minutes for hint
  static const int WRONG_ANSWER_TIMEOUT_SECONDS = 60; // 1 minute for wrong answer

  showTimeout(int seconds, String question, String hint, bool isHintTimeout) {
    time.stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    
    Get.to(
      () => TimeoutScreen(
        timeoutSeconds: seconds,
        onTimeoutComplete: () {
          Get.back();
          time.stopWatchTimer.onExecute.add(StopWatchExecute.start);
        },
        question: question,
        hint: hint,
        isHintTimeout: isHintTimeout,
      ),
    );
  }

  handleHintTimeout(String question, String hint) {
    showTimeout(HINT_TIMEOUT_SECONDS, question, hint, true);
  }

  handleWrongAnswerTimeout(String question, String hint) {
    showTimeout(WRONG_ANSWER_TIMEOUT_SECONDS, question, hint, false);
  }
}

class LifeCountCounter extends GetxController {
  var lifeCount = 3.abs();
  String? currentQuestion;
  String? currentHint;

  void setCurrentQuestion(String question, String hint) {
    currentQuestion = question;
    currentHint = hint;
  }

  removeLife() {
    lifeCount--;
  }

  restoreLife() {
    if (lifeCount == 0) {
      if (currentQuestion != null && currentHint != null) {
        Get.find<ExtraTimeCounter>().handleWrongAnswerTimeout(currentQuestion!, currentHint!);
      }
      lifeCount = 3;
    }
  }
}
