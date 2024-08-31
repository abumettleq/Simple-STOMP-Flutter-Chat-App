
class ChatModel {
  int chatId;
  String slotName;
  String lastMessage;
  int userOne;
  int userTwo;

  ChatModel({
    this.chatId = 0,
    this.slotName = "",
    this.lastMessage = "",
    this.userOne = 0,
    this.userTwo = 0,
  });

  // Factory constructor to create a ChatModel instance from JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['chatId'] ?? 0,
      slotName: json['slotName'] ?? "",
      lastMessage: json['lastMessage'] ?? "",
      userOne: json['userOne'] ?? 0,
      userTwo: json['userTwo'] ?? 0,
    );
  }

  // Optionally, you can add a toJson method if you need to convert it back to JSON
  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'slotName': slotName,
      'lastMessage': lastMessage,
      'userOne': userOne,
      'userTwo': userTwo,
    };
  }
}
