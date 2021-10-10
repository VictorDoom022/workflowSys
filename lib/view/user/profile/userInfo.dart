import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserDetail.dart';

class userInfo extends StatefulWidget {

  final int userID;

  const userInfo({Key key, this.userID}) : super(key: key);

  @override
  _userInfoState createState() => _userInfoState(userID);
}

class _userInfoState extends State<userInfo> {

  final int userID;

  _userInfoState(this.userID);

  String username = '';
  String profilePictureDir = serverURL + '/upload/userProfilePictures/userProfilePic.jpg';
  int accountEnabled;
  String accountCreateDate = '';
  String userJoinedGroupCount = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
  }

  void setUserData(){
    getUserDetailByID(userID).then((value) {
      setState(() {
        username = value.user.name;
        profilePictureDir = serverURL + '/' + value.userDetail.userDetailProfilePictureDir;
        accountEnabled = value.userDetail.userDetailAccEnable;
        accountCreateDate = convertBackendDateTime(value.user.createdAt);
        userJoinedGroupCount = calcUserJoinedGroup(value.userDetail.userDetailJoinedGroupID);
      });
    });
  }

  String calcUserJoinedGroup(String userJoinedGroupID) {
    if(userJoinedGroupID.length != 0){
      List<String> userJoinedGroupIDList = userJoinedGroupID.split(',');
      return userJoinedGroupIDList.length.toString();
    }else{
      return '0';
    }
  }

  double calcCardWidth(){
    double screenWidth = MediaQuery.of(context).size.width;
    if(screenWidth > 550){
      return screenWidth /3 ;
    }else{
      return screenWidth;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
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
                                          profilePictureDir
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                            ],
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
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Wrap(
              children: [
                accountInfoItemCard(
                    'Account Activation Status',
                    accountEnabled == 1 ? 'Enabled' : 'Banned',
                    Colors.greenAccent
                ),
                accountInfoItemCard(
                    'Account Created At',
                    accountCreateDate,
                    Colors.amberAccent
                ),
                accountInfoItemCard(
                    'Group(s) Joined',
                    userJoinedGroupCount,
                    Colors.orangeAccent
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget accountInfoItemCard(String title, String data, Color cardColor){
    return Container(
      width: calcCardWidth(),
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    data,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    title,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }

}
