import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nova_messenger/Models/chat_model.dart';
import 'package:nova_messenger/Models/message_model.dart';
import 'package:nova_messenger/Providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../Utils/user_data_holder.dart';

class ChatService {
  ChatService._();
  static final ChatService chatService = ChatService._();
  StompClient? _stompClient;

  void connect() {
    final socketUrl = "ws://${UserDataHolder.userDataHolder.hostIP}:8080/ws";
    final StompConfig config = StompConfig(
      url: socketUrl,
      onConnect: (_) {
        debugPrint('Connected to WebSocket');

         _stompClient!.subscribe(
          destination: '/chat/privateMessage',
          callback: (frame) {
            if (frame.body != null) {
              final messageData = jsonDecode(frame.body!);
              final message = MessageModel.fromJson(messageData);

              Provider.of<ChatProvider>(UserDataHolder.userDataHolder.msgContext!, listen: false)
                .onReceiveNewMessage(message);

            }
          },
        );

      },
      onWebSocketError: (error) {
        debugPrint('WebSocket error: $error');
      },
    );

    _stompClient = StompClient(config: config);
    _stompClient!.activate();
  }

  void sendMessage(ChatModel chatModel, String content) {
    if (_stompClient != null && _stompClient!.isActive) {
      MessageModel message = MessageModel(
        messageId: 0,
        chat: chatModel,
        status: 'sent',
        messageContent: content,
        senderId: UserDataHolder.userDataHolder.userId,
      );

      _stompClient!.send(
        destination: '/chat/privateMessage',
        body: jsonEncode(message),
      );
    } else {
      debugPrint("STOMP Client not connected!");
    }
  }



  void disconnect() {
    _stompClient?.deactivate();
  }
}
