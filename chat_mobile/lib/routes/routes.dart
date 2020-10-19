import 'package:chat_mobile/binding/app_binding.dart';
import 'package:chat_mobile/pages/home/home.dart';
import 'package:chat_mobile/pages/login/login.dart';
import 'package:get/route_manager.dart';

routes() => [
  GetPage(
      name: "/",
      page: () => LoginPage(),
      binding: HomeBinding(),
  ),
  GetPage(
      name: "/home",
      page: () => Home(title: 'Home Page'),
      binding: HomeBinding(),
  ),
];