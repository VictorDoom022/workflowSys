import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/Group.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/selectors/selectMember.dart';
import 'package:workflow_sys/view/user/tasks/taskHome.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';
import 'package:workflow_sys/view/user/teams/teamSettings.dart';

class teamDetail extends StatefulWidget {

  final int teamID;
  final String teamName;
  final bool isAdmin;

  const teamDetail({Key key, this.teamID, this.teamName, this.isAdmin}) : super(key: key);

  @override
  _teamDetailState createState() => _teamDetailState(teamID, teamName, isAdmin);
}

class _teamDetailState extends State<teamDetail> {

  final int teamID;
  String teamName;
  final bool isAdmin;

  _teamDetailState(this.teamID, this.teamName, this.isAdmin);

  GlobalKey<ScaffoldState> teamDetailScaffoldKey = GlobalKey();
  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<TeamDetailReceiver> futureTeamDetailReceiver;
  UserReceiver userReceiver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData().then((value) {
      getTeamDetailData();
    });
  }

  Future<void> getTeamDetailData() async {
    TeamDetailReceiver teamDetailReceiver = await getTeamDetail(teamID);
    setState(() {
      futureTeamDetailReceiver = Future.value(teamDetailReceiver);
      teamName = teamDetailReceiver.team.teamName;
    });
    refreshController.refreshCompleted();
  }

  Future<void> getUserData() async {
    UserReceiver userReceiverData = await getAllUser(context);
    setState(() {
      userReceiver = userReceiverData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Team ($teamName)'),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.more_vert),
          onPressed: (){
            HapticFeedback.lightImpact();
            showAddMemberDialog();
          },
        ),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        header: BezierCircleHeader(),
        onRefresh: getTeamDetailData,
        child: FutureBuilder<TeamDetailReceiver>(
          future: futureTeamDetailReceiver,
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);

            if(snapshot.hasData){
              return teamItem(teamDetailReceiver: snapshot.data, userReceiver: userReceiver);
            }else{
              return Center(child: CupertinoActivityIndicator(radius: 12));
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> showAddMemberDialog(){
    return showCupertinoModalPopup(
        context: context,
        builder: (_){
          return CupertinoActionSheet(
            title: Text('Choose an action'),
            actions: [
              CupertinoActionSheetAction(
                child: Text('Settings'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context){
                        return teamSettingsPage(teamID: teamID, isAdmin: isAdmin);
                      })
                  ).then((value) {
                    setState(() {
                      getTeamDetailData();
                    });
                  });
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.red
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
            ),
          );
        }
    );
  }
}

class teamItem extends StatelessWidget {

  final TeamDetailReceiver teamDetailReceiver;
  final UserReceiver userReceiver;

  const teamItem({Key key, this.teamDetailReceiver, this.userReceiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: teamDetailReceiver.taskList.length,
      itemBuilder: (context, index){
        return Card(
          elevation: 8.0,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
                convertUserIDtoName(teamDetailReceiver.taskList[index].taskListUserID) + "'s Task List",
              textAlign: TextAlign.center,
            ),
            onTap: (){
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_){
                        return taskHome(userReceiver: userReceiver, teamID: teamDetailReceiver.team.id, taskListID: teamDetailReceiver.taskList[index].id, taskListUserName: convertUserIDtoName(teamDetailReceiver.taskList[index].taskListUserID));
                      }
                  )
              );
            },
          ),
        );
      },
    );
  }

  String convertUserIDtoName(String userID){
    for(int i=0; i < userReceiver.user.length; i++){
      if(userID == userReceiver.user[i].id.toString()){
        return userReceiver.user[i].name;
      }
    }
  }
}

