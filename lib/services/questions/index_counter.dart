import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class IndexCounter extends GetxController {
  var curIndex = 0.abs();
  increment() => curIndex++;
}
