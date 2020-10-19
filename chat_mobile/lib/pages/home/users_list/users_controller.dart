import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/app_controller.dart';
import 'package:chat_mobile/data/api_client.dart';
import 'package:chat_mobile/pages/chat_content/chat_content.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_models/chat_models.dart';
import 'package:get/get.dart';


class UsersController extends GetxController {

  AppController appController = Get.find();
  RxList<User> users = RxList<User>([]);

  final status = Status.loading.obs;

  @override
  void onInit() => refreshUsers();

  Future <void> refreshUsers() async {
    List<User> foundUsers = List<User>();
    UsersClient _usersClient = UsersClient(MobileApiClient());
    foundUsers = await _usersClient.read({}).then((_) {
      foundUsers.removeWhere((user) => user.id == appController.currentUser.id);
      users = foundUsers;
      status(Status.success);
    }).catchError((e) {
      print('Failed to get list of users');
      print(e);
      status(Status.error);
    });
  }

  Future <void> createChat() async {
    var _checkedUsers = users
        .where((user) => user.isChecked == true)
        .toList();
    if (_checkedUsers.isNotEmpty) {
      try {
        Chat createdChat = Chat();
        ChatsClient chatsClient = ChatsClient(MobileApiClient());
        createdChat = await chatsClient.create(
            Chat(members: _checkedUsers..add(appController.currentUser))).
        then((_) => Get.to(ChatContentPage(chat: createdChat, title: createdChat.members
            .where((user) => user.id != appController.currentUser.id)
            .map((user) => user.name)
            .join(", "))));
      } on Exception catch (e) {
        print('Chat creation failed');
        print(e);
        Get.snackbar("Failure", "Chat creation failed",
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      }
    }
  }
}
