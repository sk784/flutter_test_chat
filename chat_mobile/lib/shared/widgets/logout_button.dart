import 'package:chat_mobile/app_controller.dart';
import 'package:chat_mobile/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppController appController = AppController();
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        tooltip: 'Logout',
        onPressed: () {
          appController.setMobileToken("");
          Get.offAll(LoginPage());
        });
  }
}
