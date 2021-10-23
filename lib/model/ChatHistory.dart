class ChatHistory {
  int? chatReceiverUserID;

  ChatHistory({this.chatReceiverUserID});

  ChatHistory.fromJson(Map<String, dynamic> json) {
    chatReceiverUserID = json['chat_receiverUserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_receiverUserID'] = this.chatReceiverUserID;
    return data;
  }
}