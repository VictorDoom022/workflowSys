import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/view/initLoading.dart';
import 'package:workflow_sys/view/misc/CustomDraggableHome.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class userHome extends StatefulWidget {
  const userHome({Key? key}) : super(key: key);

  @override
  _userHomeState createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {

  GlobalKey<ScaffoldState> userHomeScaffoldKey = GlobalKey();
  String loggedInUserName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserName();
  }

  void getCurrentUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userName = sharedPreferences.getString("UserName");
    setState(() {
      loggedInUserName = userName!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userHomeScaffoldKey,
      drawer: userNavDrawer(),
      body: CustomDraggableHome(
        alwaysShowLeadingAndAction: true,
        curvedBodyRadius: 5.0,
        leading: IconButton(
          icon: Icon(
            Icons.list,
            color: Colors.white,
          ),
          onPressed: (){
            HapticFeedback.lightImpact();
            userHomeScaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Text(
          'Home',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600
          ),
        ),
        headerBackgroundColor: Colors.black,
        headerWidget: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Welcome, ' + loggedInUserName,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                    fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
        ),
        body: [
          Container(),
        ],
      ),
    );
  }
}
