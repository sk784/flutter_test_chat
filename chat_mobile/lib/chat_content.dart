import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'chat_component.dart';
import 'globals.dart' as globals;
import 'api_client.dart';

class ChatContentPage extends StatefulWidget {
  ChatContentPage({Key key, @required this.title, @required this.chatId})
      : super(key: key);
  final String title;
  final ChatId chatId;
  final formatter = DateFormat('HH:mm');

  @override
  _ChatContentPageState createState() => _ChatContentPageState();
}

class _ChatContentPageState extends State<ChatContentPage> {
  var _messages = <Message>[];
  final _sendMessageTextController = TextEditingController();
  ChatComponent _chatComponent;

  @override
  void initState() {
    super.initState();
    refreshChatContent();
    _chatComponent = ChatComponent(globals.webSocketAddress)
      ..connect().then((_) {
        _chatComponent.messages.listen((receivedMessage) {
          if (receivedMessage.chat == widget.chatId &&
              receivedMessage.author.id != globals.currentUser.id) {
            setState(() {
              _messages.add(receivedMessage);
            });
          }
        });
      }).catchError((connectionError) {
        // TODO: websocket connection error handling here
      });
  }

  @override
  void dispose() {
    _sendMessageTextController.dispose();
    _chatComponent.dispose();
    super.dispose();
  }

  void refreshChatContent() async {
    try {
      List<Message> msgList =
          await MessagesClient(MobileApiClient()).read(widget.chatId);
      setState(() {
        _messages = msgList;
      });
    } on Exception catch (e) {
      print('Failed to get list of messages');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildListTile(_messages[index]);
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _sendMessageTextController,
                    decoration: InputDecoration(hintText: 'Your message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_sendMessageTextController.text.isNotEmpty) {
                      send(_sendMessageTextController.text);
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(Message message) {
    var isMyMessage = message.author.id == globals.currentUser.id;
    var messageTime = widget.formatter.format(message.createdAt);
    return _Bubble(
      message: message.text,
      isMe: isMyMessage,
      time: messageTime,
    );
  }

  send(String message) async {
    final newMessage = Message(
        chat: widget.chatId,
        author: globals.currentUser,
        text: message,
        createdAt: DateTime.now());
    try {
      final createdMessage =
          await MessagesClient(MobileApiClient()).create(newMessage);
      _sendMessageTextController.clear();
      setState(() {
        _messages.add(createdMessage);
      });
    } on Exception catch (e) {
      print('Sending message failed');
      print(e);
    }
  }
}

class _Bubble extends StatelessWidget {
  _Bubble({this.message, this.time, this.isMe});

  final String message, time;
  final isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(message),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
