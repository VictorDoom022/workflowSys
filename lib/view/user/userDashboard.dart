import 'dart:io';
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
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class userDashboard extends StatefulWidget {
  const userDashboard({Key? key}) : super(key: key);

  @override
  _userDashboardState createState() => _userDashboardState();
}

class _userDashboardState extends State<userDashboard> {

  GlobalKey<ScaffoldState> userHomeScaffoldKey = GlobalKey();
  DashboardData? dashboardData = DashboardData(totalTask: 0, activeTaskCount: 0, completedTaskCount: 0, highPriorityTaskCount: 0, assignedToUserTaskCount: 0, recentTaskActivityData: [], completedTaskHistoryData: []);
  String loggedInUserName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserName().then((value) {
      getDashboardData(context).then((value) {
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
    return Platform.isAndroid || Platform.isIOS ? mobileView() : desktopView();
  }

  Widget desktopView(){
    return Scaffold(
        key: userHomeScaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: bodyContent(),
          ),
        )
    );
  }

  Widget mobileView(){
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
        body: bodyContent(),
      ),
    );
  }

  List<Widget> bodyContent(){
    return [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 2,
            child: DashboardItem(
              itemTitle: 'Total Task',
              itemData: dashboardData!.totalTask.toString(),
              itemBackgroundColor: Color(0xff4f4fae),
            ),
          ),
          Expanded(
            flex: 2,
            child: DashboardItem(
              itemTitle: 'Active Task',
              itemData: dashboardData!.activeTaskCount.toString(),
              itemBackgroundColor: Color(0xff2ed694),
            ),
          ),
          Expanded(
            flex: 2,
            child: DashboardItem(
              itemTitle: 'Task Assigned To You',
              itemData: dashboardData!.assignedToUserTaskCount.toString(),
              itemBackgroundColor: Color(0xfffe6f5e),
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
              itemBackgroundColor: Color(0xffff3f78),
            ),
          ),
          Expanded(
            flex: 2,
            child: DashboardItem(
              itemTitle: 'Completed Task',
              itemData: dashboardData!.completedTaskCount.toString(),
              itemBackgroundColor: Color(0xff475afe),
            ),
          ),
        ],
      ),
      Container(
        width: double.infinity,
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
                    'Active Task / Completed Task',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  value: calcTaskProgress(),
                  valueColor: AlwaysStoppedAnimation(Color(0xff28a745)),
                  backgroundColor: Color(0xff007bff),
                  minHeight: 8,
                ),
                Text((calcTaskProgress() *100).toStringAsFixed(2) + '%'),
              ],
            ),
          ),
        ),
      ),
      Wrap(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: calcGraphWidgetWidth(),
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
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                          text: 'Recent task activity'
                      ),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<RecentTaskActivityData, String>>[
                        LineSeries<RecentTaskActivityData, String>(
                            dataSource: dashboardData!.recentTaskActivityData,
                            xValueMapper: (RecentTaskActivityData recentTaskData, _) => recentTaskData.date,
                            yValueMapper: (RecentTaskActivityData recentTaskData, _) => recentTaskData.taskCount,
                            name: 'Task Count'
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: calcGraphWidgetWidth(),
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
                    SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: ChartTitle(
                          text: 'Completed Task History'
                      ),
                      legend: Legend(isVisible: true),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <ChartSeries<CompletedTaskHistoryData, String>>[
                        LineSeries<CompletedTaskHistoryData, String>(
                            dataSource: dashboardData!.completedTaskHistoryData,
                            xValueMapper: (CompletedTaskHistoryData completeTaskData, _) => completeTaskData.date,
                            yValueMapper: (CompletedTaskHistoryData completeTaskData, _) => completeTaskData.taskCount,
                            name: 'Task Count'
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    ];
  }

  double calcGraphWidgetWidth(){
    double screenWidth = MediaQuery.of(context).size.width;

    if(screenWidth > 450){
      return screenWidth / 2;
    }else{
      return double.infinity;
    }
  }

  double calcTaskProgress(){
    int completedTaskCount = dashboardData!.completedTaskCount;
    int totalTaskCount = dashboardData!.totalTask;
    double taskProgress = (( completedTaskCount / totalTaskCount) * 1);

    if(!taskProgress.isNaN){
      return taskProgress;
    }else{
      return 1;
    }
  }
}

class DashboardItem extends StatelessWidget {

  final String itemTitle;
  final String itemData;
  final Color itemBackgroundColor;

  const DashboardItem({Key? key, required this.itemTitle, required this.itemData, required this.itemBackgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 120
      ),
      child: Card(
        color: itemBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0)
        ),
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
                      color: Colors.white
                  ),
                ),
              ),
              Text(
                itemData,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

