import 'package:flutter/material.dart';
import 'package:nova_messenger/Providers/chat_provider.dart';

import 'package:nova_messenger/Views/Private/specific_chat_screen.dart';
import 'package:provider/provider.dart';

import '../../Utils/user_data_holder.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        chatProvider.fetchUserChats();
        return Scaffold(
          appBar: AppBar(
            title: Text('Chats for ${UserDataHolder.userDataHolder.username} (${UserDataHolder.userDataHolder.userId})'),
          ),
          body: chatProvider.chats.isEmpty ?
          const Center(
            child: CircularProgressIndicator(),
          )
          :
          ListView.builder(
            itemCount: chatProvider.chats.length,
            itemBuilder: (context, index) {
              final chat = chatProvider.chats[index];
              return ListTile(
                title: Text(chat.slotName),
                subtitle: Text(chat.lastMessage),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpecificChatScreen(chatModel: chat),
                    ),
                  );
                },
              );
            },
          ),
        );
      }
    );
  }
}
