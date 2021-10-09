import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/authController.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';

class adminNavDrawer extends StatefulWidget {
  const adminNavDrawer({Key key}) : super(key: key);

  @override
  _adminNavDrawerState createState() => _adminNavDrawerState();
}

class _adminNavDrawerState extends State<adminNavDrawer> {

  final GlobalKey adminNavDrawerGlobalKey = new GlobalKey();
  String currentUserName="";
  int selectedPage = 0;

  @override
  void initState() {
    // TODO: implement initState
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
                        'Admin',
                        style: TextStyle(
                            fontSize: 30
                        ),
                      ),
                      Icon(
                        Icons.admin_panel_settings_sharp,
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
          userListTile(0),
          Divider(),
          logoutTile(),
        ],
      ),
    );
  }

  Widget userListTile(int pageNumber){
    return ListTile(
      leading: Icon(Icons.list),
      title: Text('User Lists'),
      selected: selectedPage == pageNumber,
      onTap: (){
        HapticFeedback.lightImpact();
        selectPage(pageNumber);
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
                      LoadingScreen.showLoadingScreen(context, adminNavDrawerGlobalKey);
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