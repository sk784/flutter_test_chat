import 'package:flutter/material.dart';
import 'login.dart';
import 'chat_list.dart';
import 'create_chat.dart';

void main() => runApp(SimpleChatApp());

class SimpleChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(title: 'Simple Chat Login'),
        '/chat_list': (context) => ChatListPage(title: 'Simple Chat Login'),
        '/create_chat': (context) => CreateChatPage(title: 'Create Chat'),
      },
    );
  }
}


