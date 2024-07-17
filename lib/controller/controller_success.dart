import 'dart:async';
import 'package:demo_nfc/controller/controller_home.dart';
import 'package:demo_nfc/services/mqtt_demo.dart';
import 'package:get/get.dart';

class SuccessController extends GetxController {
  // final mqttConnectionStatus = false.obs;
  get mqttConnectionStatus => Get.find<HomeController>().mqttConnectionStatus;
  get isLoading => Get.find<HomeController>().isLoading;

  final internetConnectionStatus = false.obs;

  @override
  void onInit() async {
    super.onInit();
    // await checkMqttConnection();
  }

  Future<void> checkMqttConnection() async {
    isLoading.value = true;

    const Duration retryInterval = Duration(seconds: 1);
    const int retryAttempts = 10;

    bool connected = false;

    for (int i = 0; i < retryAttempts; i++) {
      final reconnectStatus = await connect();

      if (reconnectStatus == 1) {
        mqttConnectionStatus.value = true;
        connected = true;
        break;
      }

      await Future.delayed(retryInterval);
    }

    if (!connected) {
      mqttConnectionStatus.value = false;
    }

    isLoading.value = false;
  }
}
