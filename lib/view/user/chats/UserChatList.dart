import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class userChatList extends StatefulWidget {
  const userChatList({Key key}) : super(key: key);

  @override
  _userChatListState createState() => _userChatListState();
}

class _userChatListState extends State<userChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Chats'),
      ),
      body: Container(),
    );
  }
}
