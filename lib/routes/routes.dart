import 'package:demo_nfc/binding/binding_home.dart';
import 'package:demo_nfc/routes/app_routes.dart';
import 'package:demo_nfc/views/homepage.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

// part './app_routes.dart';

class AppPages {
  static const initial = RouteName.home;

  static final pages = [
    //Welcome Page
    // GetPage(
    //   name: RouteName.splash,
    //   page: () => SplashScreen(),
    //   binding: SplashBinding(),
    // ),
    // GetPage(
    //   name: RouteName.login,
    //   page: () => Login(),
    //   binding: LoginBinding(),
    // ),
    GetPage(
      name: RouteName.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
