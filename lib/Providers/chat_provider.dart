import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nova_messenger/Models/chat_model.dart';
import 'package:nova_messenger/Models/message_model.dart';
import 'package:nova_messenger/Utils/user_data_holder.dart';

import '../Services/chat_service.dart';

class ChatProvider with ChangeNotifier 
{

  List<ChatModel> chats = [];
  List<MessageModel> messages = [];

  void fetchUserChats() async {
    final response = await http.get(Uri.parse('http://${UserDataHolder.userDataHolder.hostIP}:8080/chat/userChats/${UserDataHolder.userDataHolder.userId}'));
    if (response.statusCode == 200) {
      chats = (json.decode(response.body) as List).map((data) => ChatModel.fromJson(data)).toList();
    } else {
      debugPrint("Failed to fetch messages for user ${UserDataHolder.userDataHolder.userId}");
    }
    notifyListeners();
  }

  void fetchUserMessages(int chatId) async {
    final response = await http.get(Uri.parse('http://${UserDataHolder.userDataHolder.hostIP}:8080/chat/userMessages/$chatId'));
    if (response.statusCode == 200) {
      messages = (json.decode(response.body) as List).map((data) => MessageModel.fromJson(data)).toList();
    } else {
      debugPrint("Failed to fetch messages for user ${UserDataHolder.userDataHolder.userId}");
    }
    notifyListeners();
  }

  final TextEditingController messageController = TextEditingController();
  ChatModel? currentChatModel;
  void sendMessage() {
    final messageContent = messageController.text;
    if (messageContent.isNotEmpty) {
      ChatService.chatService.sendMessage(currentChatModel!, messageContent);
      messageController.clear();
    }
    notifyListeners();
  }

  final ScrollController scrollController = ScrollController();

  void onReceiveNewMessage(MessageModel message)
  {
    messages.add(message);

    scrollController.animateTo(
    scrollController.position.maxScrollExtent,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
    );

    notifyListeners();
  }
}