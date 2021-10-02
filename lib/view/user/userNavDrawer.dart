import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/authController.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/profile/userProfile.dart';
import 'package:workflow_sys/view/user/todos/todoHome.dart';
import 'package:workflow_sys/view/user/userHome.dart';

class userNavDrawer extends StatefulWidget {
  const userNavDrawer({Key key}) : super(key: key);

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
    String userName = sharedPreferences.getString("UserName");
    setState(() {
      currentUserName = userName;
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
                      Text(
                        'WorkflowSys',
                        style: TextStyle(
                            fontSize: 30
                        ),
                      ),
                      Icon(
                        Icons.account_tree,
                        size: 40,
                      ),
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
              return userHome();
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
