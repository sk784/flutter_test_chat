import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chats_controller.dart';

class ChatListPage extends StatefulWidget {

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with
    AutomaticKeepAliveClientMixin<ChatListPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ChatsController>(
        init: ChatsController(),
        builder: (controller) {
          return Obx(
                  () {
                final status = controller.status.value;
                if (status == Status.loading) return Center(child: CircularProgressIndicator());
                if (status == Status.error) return Center(child: Text('Failed to get list of chats'));
                return RefreshIndicator(
                  onRefresh: controller.refreshChats,
                  child: Expanded(
                        child: ListView.builder(
                          itemCount: controller.chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildListTile(controller.chats[index], controller);
                          },
                        ),
                      ),
                  );
              }
          );
        }
    );
  }


  Widget _buildListTile(Chat chat, ChatsController controller) {
    return  Obx(
            () {
              return Container(
                child: ListTile(
                  leading: controller.unreadChats.contains(chat.id)
                      ? const Icon(Icons.message) : null,
                  title: Text(chat.members.map((user) => user.name).join(", ")),
                ),
              );
            }
    );
  }


  @override
  bool get wantKeepAlive => true;
}

