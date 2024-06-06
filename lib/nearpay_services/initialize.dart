// import 'package:flutter/services.dart';

// class NearpayProxy {
//   static const platform = MethodChannel('your_channel_name');

//   static Future<void> initializeNearpay() async {
//     try {
//       await platform.invokeMethod('initializeNearpay', {
//         'port': 5000,
//         'environment': 'io.nearpay.proxy.utils.Environments.SANDBOX',
//         'networkConfiguration':
//             'io.nearpay.proxy.data.enums.NetworkConfiguration.SIM_PREFERRED',
//         'loadingUi': true
//         // Add other configuration parameters here
//       });
//     } on PlatformException catch (e) {
//       print("Failed to initialize Nearpay: '${e.message}'.");
//     }
//   }
// }
