library chat_component;

import 'package:chat_models/chat_models.dart';
import 'dart:convert';

import 'dart:async';
import 'dart:io';

/// The component incapsulates websocket connection and provides a stream
/// of received messages.
/// Might be reused in webapp.
///
/// Should be disposed after usage.
class ChatComponent {
  final String _address;
  StreamController<Message> messagesStreamController =
      StreamController.broadcast();
  WebSocket _webSocket;
  StreamSubscription _streamSubscription;

  ChatComponent(this._address);

  Future<void> connect() async {
    Future<WebSocket> ws = WebSocket.connect(_address);
    ws.then((webSocket) {
      _webSocket = webSocket;
      _streamSubscription = webSocket.listen((data) {
        if (data is String) {
          final receivedMessage = Message.fromJson(json.decode(data));
          messagesStreamController.add(receivedMessage);
        }
      });
    });
  }

  void dispose() {
    messagesStreamController.close();
    _streamSubscription?.cancel()?.then((_) {
      _webSocket?.close();
    });
  }

  Stream get messages => messagesStreamController.stream;
}
