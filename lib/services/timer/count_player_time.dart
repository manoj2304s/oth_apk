import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountPlayerTime extends GetxController {
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  // Add timeout duration to the total time
  void addTimeoutDuration(int seconds) {
    final currentTime = stopWatchTimer.rawTime.value;
    final timeoutMilliseconds = seconds * 1000; // Convert seconds to milliseconds
    stopWatchTimer.setPresetTime(mSec: currentTime + timeoutMilliseconds);
  }
}
