import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/chatController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/ChatHistory.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserDetail.dart';
import 'package:workflow_sys/model/UserReceiver.dart';

import 'ChatList.dart';

class userChatList extends StatefulWidget {
  const userChatList({Key key}) : super(key: key);

  @override
  _userChatListState createState() => _userChatListState();
}

class _userChatListState extends State<userChatList> {

  Future<List<ChatHistory>> futureChatHistory;
  UserReceiver allUserData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData().then((value) {
      getChatHistory();
    });
  }

  Future<void> fetchUserData() async {
    UserReceiver userReceiver = await getAllUser(context);
    setState(() {
      allUserData = userReceiver;
    });
  }

  Future<void> getChatHistory() async {
    List<ChatHistory> chatHistoryList = await getUserChatHistory();
    setState(() {
      futureChatHistory = Future.value(chatHistoryList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Chats'),
      ),
      body: FutureBuilder<List<ChatHistory>>(
        future: futureChatHistory,
        builder: (context, snapshot){
          if(snapshot.hasError) print(snapshot.error);

          if(snapshot.hasData){
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index){
                return chatHistoryItem(snapshot.data[index].chatReceiverUserID);
              },
            );
          }else{
            return Center(child: CupertinoActivityIndicator(radius: 12));
          }
        },
      ),
    );
  }

  Widget chatHistoryItem(int userID){
    return ListTile(
      leading: Container(
        width: 50,
        height: 53,
        child: CircleAvatar(
          radius: 23,
          backgroundImage: NetworkImage(
              serverURL + '/' + convertUserIDToUserDetail(userID).userDetailProfilePictureDir
          ),
        ),
      ),
      title: Text(
          convertUserIDToUser(userID).name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
      ),
      subtitle: Text(
        convertUserIDToUser(userID).email,
        style: TextStyle(
          fontSize: 13,
        ),
      ),
      onTap: () async {
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        int currentLogInUserID = sharedPreferences.getInt("UserID");

        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_){
                  return chatList(
                    receiverUserID: userID,
                    senderUserID: currentLogInUserID,
                  );
                }
            )
        );
      },
    );
  }

  UserDetail convertUserIDToUserDetail(int userID){
    for(int i=0; i < allUserData.user.length; i++){
      if(allUserData.user[i].id == userID){
        return allUserData.userDetail[i];
      }
    }
  }

  User convertUserIDToUser(int userID){
    for(int i=0; i < allUserData.user.length; i++){
      if(allUserData.user[i].id == userID){
        return allUserData.user[i];
      }
    }
  }
}
