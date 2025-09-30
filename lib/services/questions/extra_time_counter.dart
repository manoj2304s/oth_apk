import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oth_apk/screens/Timeout/timeout_screen.dart';
import 'package:oth_apk/services/timer/count_player_time.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ExtraTimeCounter extends GetxController {
  final CountPlayerTime time = Get.put(CountPlayerTime());

  static const int HINT_TIMEOUT_SECONDS = 180; // 3 minutes for hint
  static const int WRONG_ANSWER_TIMEOUT_SECONDS = 60; // 1 minute for wrong answer

  showTimeout(int seconds) {
    time.stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    
    Get.to(
      () => TimeoutScreen(
        timeoutSeconds: seconds,
        onTimeoutComplete: () {
          Get.back();
          time.stopWatchTimer.onExecute.add(StopWatchExecute.start);
        },
      ),
    );
  }

  handleHintTimeout() {
    showTimeout(HINT_TIMEOUT_SECONDS);
  }

  handleWrongAnswerTimeout() {
    showTimeout(WRONG_ANSWER_TIMEOUT_SECONDS);
  }
}

class LifeCountCounter extends GetxController {
  var lifeCount = 3.abs();

  removeLife() {
    lifeCount--;
  }

  restoreLife() {
    if (lifeCount == 0) {
      Get.find<ExtraTimeCounter>().handleLifeTimeout();
      lifeCount = 3;
    }
  }
}
