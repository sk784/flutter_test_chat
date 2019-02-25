import 'package:flutter/material.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_api_client/chat_api_client.dart';
import 'api_client.dart';
import 'chat_content.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_chat');
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListTile(_chats[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(Chat chat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(chat.members.map((user) => user.name).join(", ")),
          onTap: () {
            Navigator.of(context).push(
              new MaterialPageRoute(
                builder: (context) {
                  return ChatContentPage(title: 'Chat Content', chatId: chat.id,);
                },
              ),
            );
          },
        ),
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
