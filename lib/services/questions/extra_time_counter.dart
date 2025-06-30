import 'package:get/get.dart';
import 'package:oth_apk/services/timer/count_player_time.dart';

class ExtraTimeCounter extends GetxController {
  final CountPlayerTime time = Get.put(CountPlayerTime());

  var extraTime = 0.abs();
  hintIncrement() {
    extraTime += 2 * 60000;
  }

  lifeIncrement() => extraTime += 10 * 60000;
}

class LifeCountCounter extends GetxController {
  final ExtraTimeCounter extraTime = Get.put(ExtraTimeCounter());

  var lifeCount = 3.abs();

  removeLife() {
    lifeCount--;
  }

  restoreLife() {
    if (lifeCount == 0) {
      extraTime.lifeIncrement();
      lifeCount = 3;
    }
  }
}
