import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/authController.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/chats/UserChatList.dart';
import 'package:workflow_sys/view/user/profile/userProfile.dart';
import 'package:workflow_sys/view/user/todos/todoHome.dart';
import 'package:workflow_sys/view/user/userGroup.dart';

class userNavDrawer extends StatefulWidget {
  const userNavDrawer({Key? key}) : super(key: key);

  @override
  _userNavDrawerState createState() => _userNavDrawerState();
}

class _userNavDrawerState extends State<userNavDrawer> {

  final GlobalKey userNavDrawerGlobalKey = new GlobalKey();
  String currentUserName="";
  int selectedPage = 0;

  void initState(){
    super.initState();
    getCurrentUserName();
  }

  void getCurrentUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userName = sharedPreferences.getString("UserName");
    setState(() {
      currentUserName = userName!;
    });
  }

  void selectPage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Task',
                            style: TextStyle(
                                fontSize: 30,
                                color: Color(0xffe46b10),
                            ),
                          ),
                          Text(
                            'IT',
                            style: TextStyle(
                                fontSize: 30
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                          'lib/assets/app_icon.png',
                          height: 40,
                          width: 40
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome, ' + currentUserName,
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                ],
              ),
            ),
          ),
          userGroupTile(0),
          userTodoTile(1),
          userProfileTile(2),
          userChatTile(3),
          Divider(),
          logoutTile()
        ],
      ),
    );
  }

  Widget userGroupTile(int pageNumber){
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
      selected: selectedPage == pageNumber,
      onTap: (){
        HapticFeedback.lightImpact();
        selectPage(pageNumber);
        Navigator.push(context, CupertinoPageRoute(
            builder:(context){
              return userGroup();
            }
          )
        );
      },
    );
  }

  Widget userTodoTile(int pageNumber){
    return ListTile(
      leading: Icon(Icons.list_alt),
      title: Text('Todos'),
      selected: selectedPage == pageNumber,
      onTap: (){
        HapticFeedback.lightImpact();
        selectPage(pageNumber);
        Navigator.push(context, CupertinoPageRoute(
            builder:(context){
              return todoHome();
            }
        )
        );
      },
    );
  }

  Widget userProfileTile(int pageNumber){
    return ListTile(
      leading: Icon(Icons.account_circle_rounded),
      title: Text('Profile'),
      selected: selectedPage == pageNumber,
      onTap: (){
        HapticFeedback.lightImpact();
        selectPage(pageNumber);
        Navigator.push(context, CupertinoPageRoute(
            builder:(context){
              return userProfile();
            }
        )
        );
      },
    );
  }

  Widget userChatTile(int pageNumber){
    return ListTile(
      leading: Icon(Icons.chat_sharp),
      title: Text('Chats'),
      selected: selectedPage == pageNumber,
      onTap: (){
        HapticFeedback.lightImpact();
        selectPage(pageNumber);
        Navigator.push(context, CupertinoPageRoute(
            builder:(context){
              return userChatList();
            }
          )
        );
      },
    );
  }

  Widget logoutTile(){
    return ListTile(
      leading: Icon(Icons.power_settings_new),
      title: Text('Logout'),
      onTap: (){
        HapticFeedback.lightImpact();
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Logout'),
                content: Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    child: Text('No'),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: (){
                      LoadingScreen.showLoadingScreen(context, userNavDrawerGlobalKey);
                      logout(context);
                    },
                  )
                ],
              );
            }
        );
      },
    );
  }
}
