import 'dart:async';
import 'package:chat_models/chat_models.dart';

class ChatMessageStreamControllerWrapper {
  ChatId chatId;
  StreamController<Message> streamController;

  ChatMessageStreamControllerWrapper(this.chatId, this.streamController);
}