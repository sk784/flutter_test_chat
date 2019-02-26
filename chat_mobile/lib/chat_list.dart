import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';

import 'api_client.dart';
import 'chat_content.dart';
import 'common_ui.dart';

class ChatListPage extends StatefulWidget {
  ChatListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  var _chats = <Chat>[];

  @override
  void initState() {
    super.initState();
    refreshChats();
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> listTiles =
        _chats.map<Widget>((Chat chatItem) => _buildListTile(chatItem));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[LogoutButton()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_chat').then((resultValue) {
            if (resultValue != null && resultValue is bool && resultValue) {
              refreshChats();
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: listTiles.toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(Chat chat) {
    return Container(
      child: ListTile(
        title: Text(chat.members.map((user) => user.name).join(", ")),
        onTap: () {
          Navigator.of(context).push(
            new MaterialPageRoute(
              builder: (context) {
                return ChatContentPage(
                  title: 'Chat Content',
                  chatId: chat.id,
                );
              },
            ),
          );
        },
      ),
    );
  }

  void refreshChats() async {
    try {
      List<Chat> found = await ChatsClient(MobileApiClient()).read({});
      setState(() {
        _chats = found;
      });
    } on Exception catch (e) {
      print('Failed to get list of chats');
      print(e);
    }
  }
}
