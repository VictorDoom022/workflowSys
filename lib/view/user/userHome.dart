import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class userHome extends StatefulWidget {
  const userHome({Key key}) : super(key: key);

  @override
  _userHomeState createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {

  GlobalKey<ScaffoldState> userHomeScaffoldKey = GlobalKey();
  TextEditingController createGroupNameController = TextEditingController();
  ButtonStyle createGroupButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          )
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 18,
          )
      )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userHomeScaffoldKey,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            HapticFeedback.lightImpact();
            userHomeScaffoldKey.currentState.openDrawer();
          },
        ),
        middle: Text('Home'),
      ),
      drawer: userNavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            createGroupButton(),
          ],
        ),
      ),
    );
  }

  Widget createGroupButton(){
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        child: Text('Create new group'),
        style: createGroupButtonStyle,
        onPressed: (){
          showDialog(
              context: context,
              builder: (_){
                return CupertinoAlertDialog(
                  content: Column(
                    children: [
                      Text(
                        'Group name',
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5),
                      CupertinoTextField(
                        controller: createGroupNameController,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: (){
                        HapticFeedback.lightImpact();
                        Navigator.of(
                            context,
                            rootNavigator: true
                        ).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Create',
                        style: TextStyle(
                            color: Colors.blue
                        ),
                      ),
                      onPressed: (){
                        HapticFeedback.lightImpact();
                        createGroup(context, createGroupNameController.text);
                        Navigator.of(
                            context,
                            rootNavigator: true
                        ).pop();
                      },
                    )
                  ],
                );
              }
          );
        },
      ),
    );
  }
}
