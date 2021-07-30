import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:workflow_sys/model/UserReceiver.dart';

class teamDetail extends StatefulWidget {

  final int teamID;
  final String teamName;

  const teamDetail({Key key, this.teamID, this.teamName}) : super(key: key);

  @override
  _teamDetailState createState() => _teamDetailState(teamID, teamName);
}

class _teamDetailState extends State<teamDetail> {

  final int teamID;
  final String teamName;

  _teamDetailState(this.teamID, this.teamName);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Team ($teamName)'),
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
      }else{
        return 'unknown user';
      }
    }
  }
}

