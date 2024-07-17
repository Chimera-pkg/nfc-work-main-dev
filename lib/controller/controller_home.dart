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
    deviceCheck = false;
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
