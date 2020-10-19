import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:chat_mobile/shared/chat_message_stream_controller_wrapper.dart';
import 'package:chat_models/chat_models.dart';

typedef void NotificationCallback<T>(T valueObject);

class SocketRepository {

final String _address;
SocketRepository(this._address);

WebSocket _webSocket;
StreamSubscription _wsStreamSubscription;

var _chatIdsWithUnreadMessages = HashSet<ChatId>();
var _messageStreamControllers = <ChatMessageStreamControllerWrapper>[];
var _unreadMessageNotificationControllers = <StreamController<Set<ChatId>>>[];


Future<void> connect() async {
  Future<WebSocket> ws = WebSocket.connect(_address);
  ws.then((webSocket) {
    _webSocket = webSocket;
    _wsStreamSubscription = webSocket.listen((data) {
      if (data is String) {
        final receivedMessage = Message.fromJson(json.decode(data));
        ChatId chatId = receivedMessage.chat;
        bool messageConsumed = false;

        _messageStreamControllers.forEach((messageStreamControllerWrapper) {
          if (!messageStreamControllerWrapper.streamController.isClosed &&
              (messageStreamControllerWrapper.chatId == chatId)) {
            messageConsumed = true;
            messageStreamControllerWrapper.streamController.sink
                .add(receivedMessage);
          }
        });

        if (!messageConsumed) {
          _chatIdsWithUnreadMessages.add(chatId);
          _notifyUnread();
        }
      }
    })
      ..onError((err) {
        // simple websocket reconnect policy
        print(err);
        connect();
      });
  });
}

StreamSubscription<Message> subscribeMessages(
    NotificationCallback<Message> callback, ChatId chatId) {
  _chatIdsWithUnreadMessages
      .remove(chatId); // assume all messages are read in this chat
  _notifyUnread();
  var streamController = StreamController<Message>();
  _messageStreamControllers
      .add(ChatMessageStreamControllerWrapper(chatId, streamController));
  streamController.onCancel = () => streamController.close();
  return streamController.stream.listen((message) {
    callback(message);
  });
}

StreamSubscription<Set<ChatId>> subscribeUnreadMessagesNotification(
    NotificationCallback<Set<ChatId>> callback) {
  var streamController = StreamController<Set<ChatId>>();
  _unreadMessageNotificationControllers.add(streamController);
  streamController.onCancel = () => streamController.close();
  var result = streamController.stream.listen((chatIdSet) {
    callback(chatIdSet);
  });
  streamController.sink.add(_chatIdsWithUnreadMessages);
  return result;
}

void dispose() {
  _unreadMessageNotificationControllers.forEach((streamController) {
    if (!streamController.isClosed) {
      streamController.close();
    }
  });
  _unreadMessageNotificationControllers = null;

  _messageStreamControllers.forEach((streamControllerWrapper) {
    if (!streamControllerWrapper.streamController.isClosed) {
      streamControllerWrapper.streamController.close();
    }
  });
  _messageStreamControllers = null;

  _wsStreamSubscription?.cancel()?.then((_) {
    _webSocket?.close();
  });
}

void _notifyUnread() {
  _unreadMessageNotificationControllers
      .forEach((unreadMessageNotificationController) {
    if (!unreadMessageNotificationController.isClosed) {
      unreadMessageNotificationController.sink
          .add(_chatIdsWithUnreadMessages);
    }
  });
}
}
