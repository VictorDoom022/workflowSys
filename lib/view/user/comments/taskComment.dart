import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/Comment.dart';
import 'package:workflow_sys/model/UserReceiver.dart';

class taskComment extends StatefulWidget {

  final int taskID;

  const taskComment({Key? key, required this.taskID}) : super(key: key);

  @override
  _taskCommentState createState() => _taskCommentState(taskID);
}

class _taskCommentState extends State<taskComment> {

  final int taskID;

  _taskCommentState(this.taskID);

  TextEditingController commentTextEditController = new TextEditingController();
  Future<List<Comment>>? futureCommentList;
  UserReceiver? userReceiver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData().then((value){
      getComment();
    });
  }

  Future<void> getComment() async {
    List<Comment> commentList = await getTaskComments(taskID);
    setState(() {
      futureCommentList = Future.value(commentList);
    });
  }

  Future<void> getUserData() async {
    UserReceiver? userReceiverData = await getAllUser(context);
    setState(() {
      userReceiver = userReceiverData!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Comments'),
      ),
      body: FutureBuilder<List<Comment>>(
        future: futureCommentList,
        builder: (context, snapshot) {
          if(snapshot.hasError) print(snapshot.error);

          if(snapshot.hasData){
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return ListTile(
                  leading: Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: new BoxDecoration(
                        color: Colors.blue,
                        borderRadius: new BorderRadius.all(Radius.circular(50))),
                    child: CircleAvatar(
                        radius: 50, backgroundImage: NetworkImage(getUserProilePictureByUserID(snapshot.data![index].commentUserID!)!)
                    ),
                  ),
                  title: Text(convertUserIDtoName(snapshot.data![index].commentUserID!)!),
                  trailing: Text(convertBackendDateTime(snapshot.data![index].createdAt)),
                  subtitle: Text(snapshot.data![index].commentDetails!),
                );
              },
            );
          }else{
            return Center(child: CupertinoActivityIndicator(radius: 12));
          }
        }
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
                      controller: commentTextEditController,
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
                  print(commentTextEditController.text);
                  if(commentTextEditController.text != ''){
                    sendTaskComment(context, taskID, commentTextEditController.text).then((value) {
                      getComment();
                    });
                  }
                },
              )
            ],
          )
      ),
    );
  }

  String? convertUserIDtoName(int userID){
    for(int i=0; i < userReceiver!.user!.length; i++){
      if(userID == userReceiver!.user![i]!.id){
        return userReceiver!.user![i]!.name!;
      }
    }
  }

  String? getUserProilePictureByUserID(int userID){
    for(int i=0; i < userReceiver!.user!.length; i++){
      if(userID == userReceiver!.user![i]!.id){
        return serverURL + '/' + userReceiver!.userDetail![i]!.userDetailProfilePictureDir!;
      }
    }
  }
}
