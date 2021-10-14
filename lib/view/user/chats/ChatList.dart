import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chatList extends StatefulWidget {

  final int senderUserID;
  final int receiverUserID;

  const chatList({Key key, this.senderUserID, this.receiverUserID}) : super(key: key);

  @override
  _chatListState createState() => _chatListState(senderUserID, receiverUserID);
}

class _chatListState extends State<chatList> {

  final int senderUserID;
  final int receiverUserID;

  _chatListState(this.senderUserID, this.receiverUserID);

  TextEditingController chatMessageTextEditController = TextEditingController();
  bool isMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Username'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            chatItem(isMe, 'Chat msg')
          ],
        ),
      ),
        bottomNavigationBar: Container(
            padding: MediaQuery.of(context).viewInsets,
            color: Colors.grey[300],
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: TextField(
                        controller: chatMessageTextEditController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                        ),
                      )
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.blueAccent,
                  ),
                  onPressed: (){
                    print(chatMessageTextEditController.text);
                    if(chatMessageTextEditController.text != ''){

                    }
                  },
                )
              ],
            )
        )
    );
  }

  Widget chatItem(bool isCurrentUser, String chatMessage){
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isCurrentUser)
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage('http://192.168.0.181:8000/upload/userProfilePictures/2/1634130151.png'),
                ),
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blueAccent : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(isCurrentUser ? 12 : 0),
                      bottomRight: Radius.circular(isCurrentUser ? 0 : 12),
                    )),
                child: Text(
                  chatMessage,
                  style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.grey[800]
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment:
              isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  SizedBox(
                    width: 40,
                  ),
                Icon(
                  Icons.done_all,
                  size: 20,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '2020/2/12',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
