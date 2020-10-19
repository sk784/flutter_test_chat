import 'package:chat_mobile/shared/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
      return Scaffold(
       body: Obx(
          ()
        {
        final status = controller.status.value;
        if (status == Status.loading)
          return Center(child: CircularProgressIndicator());
        if (status == Status.error)
          return Center(child: Text('Failed to get list of chats'));
        return
          Container(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: controller.loginController,
                      validator: controller.validateLogin,
                      onSaved: (String value) {
                        controller.loginController.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Login',
                          labelText: 'Enter your login'
                      ),
                    ),
                    TextFormField(
                      controller: controller.passwordController,
                      obscureText: true,
                      validator: controller.validatePassword,
                      onSaved: (String value) {
                        controller.passwordController.text = value;
                      },
                      decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Enter your password'
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                              child: Text("Login"),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  controller.login();
                                }
                              }
                          ),
                          RaisedButton(
                            child: Text("Sign up"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                controller.signUp(context);
                              }
                            },
                          ),
                        ],),
                    ),
                  ],
                ),
              ),
            ),
          );
      }
      )
      );
        }
      );
  }
}
