import 'dart:async';
import 'package:demo_nfc/services/mqtt_demo.dart';
import 'package:get/get.dart';

class SuccessController extends GetxController {
  final isLoading = false.obs;
  final mqttConnectionStatus = false.obs;
  final internetConnectionStatus = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await checkMqttConnection();
  }

  Future<void> checkMqttConnection() async {
    isLoading.value = true;
    final connectionStatus = await connect();
    if (connectionStatus == 1) {
      mqttConnectionStatus.value = true;
    } else {
      mqttConnectionStatus.value = false;
    }
    isLoading.value = false;
  }
}
