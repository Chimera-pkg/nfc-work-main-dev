import 'package:demo_nfc/config/colors.dart';
import 'package:demo_nfc/config/images.dart';
import 'package:demo_nfc/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:demo_nfc/controller/controller_success.dart';

final controller = Get.put(SuccessController());

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: LoadingAnimationWidget.waveDots(
            color: AppColors.primaryColor,
            size: MediaQuery.sizeOf(context).height * 0.08,
          ),
        );
      } else {
        if (!controller.mqttConnectionStatus.value ||
            !controller.internetConnectionStatus.value) {
          return AlertDialog(
            title: const Text('FAILED'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('client connection failed'),
                  Text('disconnecting'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  // Navigator.of(context).pop();
                },
              ),
            ],
          );
        } else {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 245, 243, 243),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Row(
                children: [
                  Text(
                    'Your ',
                    style: TextStyle(
                        color: AppColors.secondaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Logo',
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.language),
                  onPressed: () {
                    // Add functionality here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Add functionality here
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              color: AppColors.primaryColor,
                              DefaultImages.product,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1 Minutes Message",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "SAR 1.00",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: WebViewWidget(
                      controller: WebViewController()
                        ..setJavaScriptMode(JavaScriptMode.unrestricted)
                        ..setBackgroundColor(const Color(0x00000000))
                        ..setNavigationDelegate(
                          NavigationDelegate(
                            onProgress: (int progress) {
                              // Update loading bar.
                            },
                            onPageStarted: (String url) {},
                            onPageFinished: (String url) {},
                            onWebResourceError: (WebResourceError error) {},
                            onNavigationRequest: (NavigationRequest request) {
                              if (request.url.startsWith(
                                  'https://ava.sa/pos/?board_id=AVA-BC27873E0&selection=1')) {
                                return NavigationDecision.prevent;
                              }
                              return NavigationDecision.navigate;
                            },
                          ),
                        )
                        ..loadRequest(
                          Uri.parse(
                              'https://ava.sa/pos/?board_id=AVA-BC27873E0&selection=1'),
                        ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        const Text(
                          "Timer Count Down",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 30),
                        TimerCountdown(
                          timeTextStyle: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          format: CountDownTimerFormat.hoursMinutesSeconds,
                          endTime: DateTime.now().add(
                            const Duration(
                              hours: 0,
                              minutes: 0,
                              seconds: 60,
                            ),
                          ),
                          onEnd: () {
                            Get.to(() => HomePage());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
    });
  }
}
