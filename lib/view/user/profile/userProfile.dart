import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserDetail.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class userProfile extends StatefulWidget {
  const userProfile({Key key}) : super(key: key);

  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {

  GlobalKey<ScaffoldState> userProfileScaffoldKey = GlobalKey();
  User user;
  UserDetail userDetail;
  String username = '';
  String profilePictureDir;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetailByID().then((value) {
      setState(() {
        username = value.user.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userProfileScaffoldKey,
      drawer: userNavDrawer(),
      appBar: CupertinoNavigationBar(
        middle: Text('User Profile'),
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            userProfileScaffoldKey.currentState.openDrawer();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Stack(
                        fit: StackFit.loose,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      image: new NetworkImage(
                                          'http://192.168.0.181:8000/upload/userProfilePictures/2/1633080725.jpg'
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 90.0,
                                  left: 100.0
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      color: Colors.white,
                                      onPressed: (){

                                      },
                                    ),
                                  )
                                ],
                              )
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                      username,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
