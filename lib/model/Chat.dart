class Chat {
  int id;
  int chatSenderUserID;
  int chatReceiverUserID;
  String chatMessage;
  String createdAt;
  String updatedAt;

  Chat(
      {this.id,
        this.chatSenderUserID,
        this.chatReceiverUserID,
        this.chatMessage,
        this.createdAt,
        this.updatedAt});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatSenderUserID = json['chat_senderUserID'];
    chatReceiverUserID = json['chat_receiverUserID'];
    chatMessage = json['chat_message'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chat_senderUserID'] = this.chatSenderUserID;
    data['chat_receiverUserID'] = this.chatReceiverUserID;
    data['chat_message'] = this.chatMessage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}