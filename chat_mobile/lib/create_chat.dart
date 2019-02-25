import 'package:flutter/material.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'globals.dart' as globals;
import 'api_client.dart';

class CreateChatPage extends StatefulWidget {
  CreateChatPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreateChatPageState createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  var _checkableUsers = <_CheckableUser>[];

  @override
  void initState() {
    super.initState();
    refreshUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _checkableUsers.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListTile(_checkableUsers[index]);
                },
              ),
            ),
            RaisedButton(
                child: Text("Create"),
                onPressed: () {
                  createChat();
                }),
          ],
        ));
  }

  ListTile _buildListTile(_CheckableUser checkableUser) {
    return ListTile(
      title: Text(checkableUser.user.name ?? "noname"),
      trailing: Checkbox(
          value: checkableUser.isChecked,
          onChanged: (bool value) {
            setState(() {
              checkableUser.isChecked = value;
            });
          }),
    );
  }

  void refreshUsers() async {
    try {
      UsersClient _usersClient = UsersClient(MobileApiClient());
      List<User> found = await _usersClient.read({});
      found.removeWhere((user) => user.id == globals.currentUser.id);
      setState(() {
        _checkableUsers = found.map((foundUser) {
          return _CheckableUser(user: foundUser);
        }).toList();
      });
    } on Exception catch (e) {
      print('Failed to get list of users');
      print(e);
    }
  }

  void createChat() async {
    var _checkedCounterparts = _checkableUsers
        .where((checkableUser) => checkableUser.isChecked == true)
        .map((checkableUser) => checkableUser.user)
        .toList();
    if (_checkedCounterparts.isNotEmpty) {
      try {
        ChatsClient chatsClient = ChatsClient(MobileApiClient());
        final newChat = await chatsClient.create(
            Chat(members: _checkedCounterparts..add(globals.currentUser)));
        Navigator.pop(context);
      } on Exception catch (e) {
        print('Chat creation failed');
        print(e);
      }
    }
  }
}

class _CheckableUser {
  final User user;
  bool isChecked;

  _CheckableUser({
    this.user,
    this.isChecked = false,
  });
}
