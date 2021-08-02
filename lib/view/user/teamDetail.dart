import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/Group.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/selectMember.dart';

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
  final String teamName;
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
    getUserData();
    getTeamDetailData();
  }

  Future<void> getTeamDetailData() async {
    TeamDetailReceiver teamDetailReceiver = await getTeamDetail(teamID);
    setState(() {
      futureTeamDetailReceiver = Future.value(teamDetailReceiver);
    });
    refreshController.refreshCompleted();
  }

  Future<void> getUserData() async {
    UserReceiver userReceiverData = await getAllUser(context);
    setState(() {
      userReceiver = userReceiverData;
    });
  }

  Future<List<User>> getUserNotJoinedTeamList() async {
    TeamDetailReceiver teamDetailReceiver = await futureTeamDetailReceiver;
    List<User> userList = await getUserNotJoinedTeam(int.parse(teamDetailReceiver.team.teamGroupID), teamID);

    return userList;
  }

  Future<List<User>> getUserJoinedTeamList() async {
    List<User> userList = await getUserJoinedTeam(teamID);

    return userList;
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
              isAdmin == true ? CupertinoActionSheetAction(
                child: Text('Add member'),
                onPressed: () async {
                  LoadingScreen.showLoadingScreen(context, teamDetailScaffoldKey);
                  getUserNotJoinedTeamList().then((value) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context){
                          return selectMember(type: 1, teamID: teamID, userList: value);
                        })
                    );
                  });
                },
              ) : Container(),
              isAdmin == true ? CupertinoActionSheetAction(
                child: Text('Remove member'),
                  onPressed: () async {
                    LoadingScreen.showLoadingScreen(context, teamDetailScaffoldKey);
                    getUserJoinedTeamList().then((value) {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context){
                            return selectMember(type: 2, teamID: teamID, userList: value);
                          })
                      );
                    });
                  },
              ) : Container(),
              CupertinoActionSheetAction(
                child: Text('View members in team'),
                onPressed: () async {
                  LoadingScreen.showLoadingScreen(context, teamDetailScaffoldKey);
                  getUserJoinedTeamList().then((value) {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context){
                          return selectMember(type: 3, teamID: teamID, userList: value);
                        })
                    );
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
        return ListTile(
          title: Text(convertUserIDtoName(teamDetailReceiver.taskList[index].taskListUserID) + "'s Task List"),
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

