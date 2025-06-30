import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountPlayerTime extends GetxController {
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );
}
