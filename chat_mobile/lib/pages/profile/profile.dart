import 'package:chat_mobile/pages/profile/profile_controller.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(body: Obx(() {
            final status = controller.status.value;
            if (status == Status.loading)
              return Center(child: CircularProgressIndicator());
            if (status == Status.error)
              return Center(child: Text('Failed to save user data'));
            return Container(
              padding: EdgeInsets.all(20.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          controller: controller.nameController,

                          validator: controller.validateName,
                          onSaved: (String value) {
                            controller.nameController.text = value;
                          },
                          decoration: InputDecoration(
                              hintText: 'Name', labelText: 'Enter your name'),
                        ),
                        TextFormField(
                          controller: controller.phoneController,

                          validator: controller.validatePhone,
                          onSaved: (String value) {
                            controller.phoneController.text = value;
                          },
                          decoration: InputDecoration(
                              hintText: 'Phone', labelText: 'Enter your phone'),
                        ),
                        TextFormField(
                          controller: controller.emailController,

                          validator: controller.validateEmail,
                          onSaved: (String value) {
                            controller.emailController.text = value;
                          },
                          decoration: InputDecoration(
                              hintText: 'E-Mail',
                              labelText: 'Enter your e-mail'),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: RaisedButton(
                              child: Text("Save"),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  controller.save();
                                }
                              }),
                        ),
                      ]),
                ),
              ),
            );
          }));
        });
  }
}
