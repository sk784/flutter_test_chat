import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/data/api_client.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_controller.dart';

class ProfileController extends GetxController {
  AppController appController = Get.find();
  final TextEditingController nameController =  TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final status = Status.success.obs;


  String validateName(String value) {
    if (value.length < 2) {
      return 'The Name must be at least 2 characters.';
    }
    return null;
  }

  String validatePhone(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    }
    else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  String validateEmail(String value) {
    Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter e-mail';
    }
    else if (!regex.hasMatch(value)) {
      return "Incorrect e-mail";
    }
    else
      return null;
  }


  Future <void> save() async {
    status(Status.loading);
    UsersClient usersClient = UsersClient(MobileApiClient());
    await usersClient
            .update(User(
                name: nameController.text.trim(),
                phone: int.parse(phoneController.text.trim()),
                email: emailController.text.trim())
            )
            .then((updatedUser) {
          status(Status.success);
          nameController.clear();
          phoneController.clear();
          emailController.clear();
          Get.snackbar("Success", "User \'${updatedUser.name}\' updated",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 5),
              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
              colorText: Get.theme.snackBarTheme.actionTextColor);
        }).catchError((signUpError) {
          status(Status.error);
          print('Updating failed');
          print(signUpError);
        });
      }

  @override
  void onClose() {
    nameController?.dispose();
    phoneController?.dispose();
    emailController?.dispose();
    super.onClose();
  }
}