import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/data/api_client.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_controller.dart';

class LoginController extends GetxController {
  AppController appController = Get.find();
  final TextEditingController loginController =  TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final status = Status.loading.obs;

  @override
  void onInit() => checkToken();

 Future<void> checkToken() async{
   await appController.getMobileToken().then((token) {
     if (token!=""){
       Get.toNamed("/home");
     }
   status(Status.success);
   }).catchError((e) {
   print('Failed to load token');
   print(e);
   status(Status.error);
   });
 }

  String validateLogin(String value) {
    if (value.length < 2) {
      return 'The Login must be at least 2 characters.';
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.length < 2) {
      return 'The Password must be at least 2 characters.';
    }
    return null;
  }


 Future<void> login() async {
    try {
      UsersClient usersClient = UsersClient(MobileApiClient());
      await usersClient.login(loginController.text.trim(), passwordController.text.trim())
          .then((value) {
        appController.setUser(value);
        Get.toNamed("/home");
        loginController.clear();
        passwordController.clear();
      }
      );
    } on Exception catch (e) {
      Get.snackbar("Login Failed", "Unfortunately it's impossible to login now",
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
      print('Login failed');
      print(e);
    }
  }

  Future <void> signUp(BuildContext context) async {
    _showDialog(loginController.text.trim(), context).then((resultValue) async{
      if (resultValue != null && resultValue is bool && resultValue) {
        UsersClient usersClient = UsersClient(MobileApiClient());
        await usersClient
            .create(
            User(name: loginController.text.trim(), password: passwordController.text.trim()))
            .then((createdUser) {
          loginController.clear();
          passwordController.clear();
          Get.snackbar("Success", "User \'${createdUser.name}\' created",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 5),
              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
              colorText: Get.theme.snackBarTheme.actionTextColor);
        }).catchError((signUpError) {
          Get.snackbar("Failure", "Sign up failed: ${signUpError.message}",
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 3),
              backgroundColor: Get.theme.snackBarTheme.backgroundColor,
              colorText: Get.theme.snackBarTheme.actionTextColor);
          print('Sign up failed');
          print(signUpError);
        });
      }
    });
  }

Future<bool> _showDialog(String username, BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text("Do you want to create user '$username' ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Get.back(result: false);
            },
          ),
          FlatButton(
            child: Text("Ok"),
            onPressed: () {
              Get.back(result: true);
            },
          ),
        ],
      );
    },
  );
}

  @override
  void onClose() {
    loginController?.dispose();
    passwordController?.dispose();
    super.onClose();
  }

}