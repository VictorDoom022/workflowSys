import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/dashboardController.dart';
import 'package:workflow_sys/model/DashboardData.dart';
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
  DashboardData? dashboardData = DashboardData(totalTask: 0, activeTaskCount: 0, completedTaskCount: 0, highPriorityTaskCount: 0, assignedToUserTaskCount: 0, recentTaskActivityData: [], completedTaskHistoryData: []);
  String loggedInUserName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserName().then((value) {
      getDashboardData().then((value) {
        setState(() {
          dashboardData = value!;
        });
      });
    });
  }

  Future getCurrentUserName() async {
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
        titleBackgroundColor: Colors.black,
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
          Container(
            width: double.infinity,
            child: DashboardItem(
              itemTitle: 'Total Task',
              itemData: dashboardData!.totalTask.toString(),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: DashboardItem(
                  itemTitle: 'Active Task',
                  itemData: dashboardData!.activeTaskCount.toString(),
                ),
              ),
              Expanded(
                flex: 2,
                child: DashboardItem(
                  itemTitle: 'Task Assigned To You',
                  itemData: dashboardData!.assignedToUserTaskCount.toString(),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: DashboardItem(
                  itemTitle: 'High Priority Task',
                  itemData: dashboardData!.highPriorityTaskCount.toString(),
                ),
              ),
              Expanded(
                flex: 2,
                child: DashboardItem(
                  itemTitle: 'Completed Task',
                  itemData: dashboardData!.completedTaskCount.toString(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {

  final String itemTitle;
  final Color? titleTextColor;
  final String itemData;
  final Color? dataTextColor;

  const DashboardItem({Key? key, required this.itemTitle, this.titleTextColor, required this.itemData, this.dataTextColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 120
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  itemTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: titleTextColor
                  ),
                ),
              ),
              Text(
                itemData,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: dataTextColor
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

