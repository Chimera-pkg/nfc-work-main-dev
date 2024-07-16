import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:demo_nfc/services/mqtt_demo.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;
  final mqttConnectionStatus = false.obs;
  final internetConnectionStatus = false.obs;

  @override
  void onInit() {
    super.onInit();
    // checkMqttConnection();
    // Timer.periodic(const Duration(seconds: 10), (_) {
    //   checkMqttConnection();
    // });

    checkConnection();
    Connectivity().onConnectivityChanged.listen((result) {
      checkConnection();
    });
  }

  void checkConnection() async {
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      internetConnectionStatus.value = true;
    } else {
      internetConnectionStatus.value = false;
    }
  }

  Future<void> checkMqttConnection() async {
    mqttConnectionStatus.value = false;
    isLoading.value = true;
    try {
      final connectionStatus = await connect();
      if (connectionStatus == 1) {
        mqttConnectionStatus.value = true;
      }
      isLoading.value = false;
    } catch (e) {
      mqttConnectionStatus.value = false;
      isLoading.value = false;
      e.toString();
    }
  }
}
