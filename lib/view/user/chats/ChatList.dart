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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Username'),
      ),
      body: Container(),
    );
  }
}
