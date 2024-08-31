
import 'package:nova_messenger/Models/chat_model.dart';

class MessageModel {
  int messageId;
  ChatModel? chat;
  String status;
  String messageContent;
  DateTime sentAt;
  int senderId;

  MessageModel({
    this.messageId = 0,
    this.chat,
    this.status = "",
    this.messageContent = "",
    this.senderId = 0,
    DateTime? sentAt,
  }) : sentAt = sentAt ?? DateTime.now();

  // Factory constructor to create a MessageModel instance from JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId'] ?? 0,
      chat: ChatModel.fromJson(json['chat']),
      status: json['status'] ?? "",
      messageContent: json['messageContent'] ?? "",
      senderId: json['senderId'],
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'])
          : DateTime.now(),
    );
  }

  // Optionally, you can add a toJson method if you need to convert it back to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'chat': chat,
      'status': status,
      'messageContent': messageContent,
      'senderId' : senderId,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
