import 'package:chat_mobile/app_controller.dart';
import 'package:chat_mobile/pages/login/login.dart';
import 'package:chat_mobile/pages/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.person),
        tooltip: 'Profile',
        onPressed: () {
          Get.to(ProfilePage());
        });
  }
}
