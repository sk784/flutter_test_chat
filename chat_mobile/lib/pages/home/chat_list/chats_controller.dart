import 'dart:async';
import 'dart:collection';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/app_controller.dart';
import 'package:chat_mobile/data/api_client.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_models/chat_models.dart';
import 'package:get/get.dart';


class ChatsController extends GetxController {

  AppController appController = Get.find();
  RxList<Chat> chats = RxList<Chat>([]);

  final status = Status.loading.obs;
  Set<ChatId> unreadChats = HashSet<ChatId>();
  StreamSubscription<Set<ChatId>> _unreadMessagesSubscription;

  @override
  void onInit() {
    refreshChats();
    _unreadMessagesSubscription =
        appController.socketRepository.subscribeUnreadMessagesNotification(
                (unreadChatIds) {
              unreadChats.clear();
              unreadChats.addAll(unreadChatIds);
            });
  }

  Future <void> refreshChats() async {
      chats = await ChatsClient(MobileApiClient()).read({}).then((_) {
        status(Status.success);
    }).catchError((e) {
      print('Failed to get list of chats');
      print(e);
      status(Status.error);
    });
  }

  @override
  void onClose() {
    _unreadMessagesSubscription.cancel();
    super.onClose();
  }
}
