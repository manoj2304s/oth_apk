import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RandomNumberGenerator extends GetxController {
  var randomPicker = List<int>.generate(8, (i) => i + 1)..shuffle();
}
