import 'package:connectivity_plus/connectivity_plus.dart';
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
}
