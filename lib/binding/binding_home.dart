import 'package:demo_nfc/controller/controller_home.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    // Get.lazyPut<HomeController>(() => HomeController());
  }
}
