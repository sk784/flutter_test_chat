import 'package:chat_api_client/chat_api_client.dart';
import 'package:chat_mobile/pages/chat_content/chat_content_controller.dart';
import 'package:chat_mobile/shared/globals.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ChatContentPage extends StatelessWidget {
  ChatContentPage({Key key, @required this.chat, @required this.title})
      : super(key: key);

  final Chat chat;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatContentController>(
        init: ChatContentController(),
        builder: (controller) {
          return Obx(
                  () {
                    controller.refreshChatContent(chat.id);
                    controller.subscribeMessage(chat.id);
                final status = controller.status.value;
                if (status == Status.loading)
                  return CircularProgressIndicator();
                if (status == Status.error)
                  return Text('Failed to get list of chats');
                return Scaffold(
                  appBar: AppBar(
                    title: Text(title),
                    actions: controller.addActions(),
                  ),
                  body: Container(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.messages.length,
                            itemBuilder: (BuildContext context, int index) {
                              return controller.buildListTile(
                                  controller.messages[index]);
                            },
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: controller
                                    .sendMessageTextController,
                                decoration: InputDecoration(
                                    hintText: 'Your message'),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                if (controller.sendMessageTextController.text.isNotEmpty) {
                                  controller.send(
                                      controller.sendMessageTextController.text,
                                      chat.id);
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
          );
        }
    );
  }
}



