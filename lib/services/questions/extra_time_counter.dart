import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oth_apk/screens/Timeout/timeout_screen.dart';
import 'package:oth_apk/services/timer/count_player_time.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ExtraTimeCounter extends GetxController {
  final CountPlayerTime time = Get.put(CountPlayerTime());

  static const int HINT_TIMEOUT_SECONDS = 10; // 3 minutes for hint
  static const int WRONG_ANSWER_TIMEOUT_SECONDS = 10; // 1 minute for wrong answer

  showTimeout(int seconds, String question, String hint, bool isHintTimeout) {
    // Stop the main timer
    time.stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    
    Get.to(
      () => TimeoutScreen(
        timeoutSeconds: seconds,
        onTimeoutComplete: () {
          // Add the timeout duration to the total time
          time.addTimeoutDuration(seconds);
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
  int _lifeCount = 3;
  String? currentQuestion;
  String? currentHint;

  int get lifeCount => _lifeCount;

  void setCurrentQuestion(String question, String hint) {
    currentQuestion = question;
    currentHint = hint;
  }

  void removeLife() {
    if (_lifeCount > 0) {
      _lifeCount--;
      update(); // Notify GetX about the change
    }
  }

  void restoreLife() {
    if (_lifeCount == 0) {
      if (currentQuestion != null && currentHint != null) {
        Get.find<ExtraTimeCounter>().handleWrongAnswerTimeout(
          currentQuestion!,
          currentHint!
        );
      }
      _lifeCount = 3;
      update(); // Notify GetX about the change
    }
  }
}
