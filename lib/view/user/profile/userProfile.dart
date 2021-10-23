import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class userProfile extends StatefulWidget {
  const userProfile({Key? key}) : super(key: key);

  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {

  GlobalKey<ScaffoldState> userProfileScaffoldKey = GlobalKey();
  GlobalKey<ScaffoldState> userProfileScaffoldKeyForLoadingScreen = GlobalKey();

  String username = '';
  String profilePictureDir = serverURL + '/upload/userProfilePictures/userProfilePic.jpg';
  int? accountEnabled;
  String accountCreateDate = '';
  String userJoinedGroupCount = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
  }

  void setUserData(){
    getCurrentLogInUserDetail().then((value) {
      setState(() {
        username = value!.user!.name!;
        profilePictureDir = serverURL + '/' + value.userDetail!.userDetailProfilePictureDir!;
        accountEnabled = value.userDetail!.userDetailAccEnable;
        accountCreateDate = convertBackendDateTime(value.user!.createdAt);
        userJoinedGroupCount = calcUserJoinedGroup(value.userDetail!.userDetailJoinedGroupID!);
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
      key: userProfileScaffoldKey,
      drawer: userNavDrawer(),
      appBar: CupertinoNavigationBar(
        middle: Text('User Profile'),
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            userProfileScaffoldKey.currentState!.openDrawer();
          },
        ),
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
                                      onPressed: () async {
                                        FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles(
                                          type: FileType.image
                                        );

                                        if(filePickerResult != null){
                                          LoadingScreen.showLoadingScreen(context, userProfileScaffoldKeyForLoadingScreen);
                                          File file = File(filePickerResult.files.single.path!);
                                          uploadProfilePicture(context, filePickerResult.paths.first!).then((value) {
                                            setUserData();
                                          });
                                        }
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
