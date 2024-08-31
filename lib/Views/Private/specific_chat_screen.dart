import 'package:flutter/material.dart';
import 'package:nova_messenger/Models/chat_model.dart';
import 'package:nova_messenger/Providers/chat_provider.dart';
import 'package:nova_messenger/Utils/user_data_holder.dart';
import 'package:provider/provider.dart';

class SpecificChatScreen extends StatefulWidget {
  final ChatModel chatModel;

  const SpecificChatScreen({super.key, required this.chatModel});

  @override
  SpecificChatScreenState createState() => SpecificChatScreenState();
}

class SpecificChatScreenState extends State<SpecificChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        chatProvider.currentChatModel = widget.chatModel;
        chatProvider.fetchUserMessages(widget.chatModel.chatId);
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.chatModel.slotName),
          ),
          body: chatProvider.messages.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: chatProvider.scrollController,
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          UserDataHolder.userDataHolder.msgContext = context;
                          final message = chatProvider.messages[index];
                          final isSender =
                              message.senderId == UserDataHolder.userDataHolder.userId;
                          return Row(
                            mainAxisAlignment: isSender
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7),
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? Colors.blue[100]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: isSender
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.messageContent,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      message.sentAt.toLocal().toString(),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: chatProvider.messageController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your message...',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: chatProvider.sendMessage,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
