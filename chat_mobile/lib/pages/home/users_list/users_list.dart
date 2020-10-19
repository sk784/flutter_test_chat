import 'package:chat_mobile/pages/home/users_list/users_controller.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersListPage extends StatefulWidget {

  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> with
    AutomaticKeepAliveClientMixin<UsersListPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<UsersController>(
        init: UsersController(),
        builder: (controller) {
        return Obx(
           () {
            final status = controller.status.value;
             if (status == Status.loading) return Center(child: CircularProgressIndicator());
             if (status == Status.error) return Center(child: Text('Failed to get list of users'));
              return RefreshIndicator(
                 onRefresh: controller.refreshUsers,
                 child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                         itemCount: controller.users.length,
                         itemBuilder: (BuildContext context, int index) {
                          return _buildListTile(controller.users[index]);
                          },
                        ),
                      ),
                    Visibility(
                      visible: controller.users.firstWhere((user) => user.isChecked)!=null,
                       child: FloatingActionButton(
                          child: Icon(Icons.add),
                           onPressed: () {
                           controller.createChat();
                                  }),
                              ),
                            ],
                            ),
                         );
                           }
                      );
                    }
                    );
  }

  Widget _buildListTile(User user) {
    return Obx(
            () {
              return Container(
                color: user.isChecked ? Get.theme.accentColor :
                Get.theme.primaryColor,
                child: ListTile(
                  leading: CircleAvatar(
                      child: Text(user.name.substring(0, 0) ?? "?",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18.0
                        ),
                      )
                  ),
                  title: Text(user.name ?? "No Name",
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  subtitle: Text(user.email ?? "-"),
                  onTap: () => user.isChecked?
                  user.isChecked = false: user.isChecked = true,
                ),
              );
            }
    );
  }

  @override
  bool get wantKeepAlive => true;
}