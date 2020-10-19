import 'package:chat_mobile/pages/home/chat_list/chat_list.dart';
import 'package:chat_mobile/pages/home/users_list/users_list.dart';
import 'package:chat_mobile/shared/widgets/logout_button.dart';
import 'package:chat_mobile/shared/widgets/profile_button.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            ProfileButton(),
            LogoutButton()
          ],
          automaticallyImplyLeading: false,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Users List"),
              Tab(text: "Chat List"),
            ],
          ),
          title: Text(title),
        ),
        body: TabBarView(
          children: [
            UsersListPage(),
            ChatListPage()
          ],
        ),
      ),
    );
  }
}