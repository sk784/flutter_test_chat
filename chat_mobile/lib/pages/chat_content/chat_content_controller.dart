import 'dart:async';
import 'dart:collection';
import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/app_controller.dart';
import 'package:chat_mobile/data/api_client.dart';
import 'package:chat_mobile/pages/chat_content/widgets/bubble.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_mobile/shared/widgets/logout_button.dart';
import 'package:chat_mobile/shared/widgets/profile_button.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatContentController extends GetxController {

  AppController appController = Get.find();
  RxList<Message> messages = RxList<Message>([]);
  Set<ChatId> unreadChats = HashSet<ChatId>();
  StreamSubscription<Set<ChatId>> _unreadMessagesSubscription;
  final TextEditingController sendMessageTextController = TextEditingController();
  final status = Status.loading.obs;
  StreamSubscription<Message> messagesSubscription;
  final formatter = DateFormat('HH:mm');

  @override
  void onInit() {
    _unreadMessagesSubscription = appController.socketRepository.subscribeUnreadMessagesNotification(
            (unreadChatIds) {
          unreadChats.clear();
          unreadChats.addAll(unreadChatIds);
        });
  }

  Future <void> refreshChatContent(ChatId chatId) async {
    messages = await ChatsClient(MobileApiClient()).read({chatId}).then((_) {
      status(Status.success);
    }).catchError((e) {
      print('Failed to get list of chats');
      print(e);
      status(Status.error);
    });
  }

  Future <void> subscribeMessage(ChatId chatId) async {
    messagesSubscription =
        appController.socketRepository.subscribeMessages((receivedMessage) {
          messages.add(receivedMessage);
        }, chatId);
  }

  List<Widget> addActions(){
    var actions = <Widget>[];
    if (unreadChats.isNotEmpty) {
     actions.add(IconButton(
         icon: Icon(Icons.message),
         tooltip: 'New messages',
         color: Colors.greenAccent,
         onPressed: () {
           Get.back();
         }));
   }
    actions.add(ProfileButton());
   actions.add(LogoutButton());
   return actions;
 }

  Widget buildListTile(Message message) {
    var isMyMessage = message.author.id == appController.currentUser.id;
    var messageTime = formatter.format(message.createdAt);
    return Bubble(
              message: message.text,
              isMe: isMyMessage,
              time: messageTime,
    );
  }

  Future<void>send(String message, ChatId chatId) async {
    final newMessage = Message(
        chat: chatId,
        author: appController.currentUser,
        text: message,
        createdAt: DateTime.now());
    try {
      await MessagesClient(MobileApiClient()).create(newMessage);
      sendMessageTextController.clear();
    } on Exception catch (e) {
      print('Sending message failed');
      print(e);
    }
  }


  @override
  void onClose() {
    _unreadMessagesSubscription.cancel();
    sendMessageTextController.dispose();
    messagesSubscription.cancel();
    super.onClose();
  }
}
