import 'package:demo_nfc/nearpay_services/nearpay_services.dart';
import 'package:demo_nfc/routes/routes.dart';
import 'package:demo_nfc/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NearpayService().initializeNearpay();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NFC Demo',
      debugShowCheckedModeBanner: false,
      // home: HomePage(),
      getPages: AppPages.pages,
      initialRoute: AppPages.initial,
    );
  }
}
