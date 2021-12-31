import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/setupDir.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/Group.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/model/taskList.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/comments/AwesomeListItem.dart';
import 'package:workflow_sys/view/user/selectors/selectMember.dart';
import 'package:workflow_sys/view/user/tasks/taskHome.dart';
import 'package:workflow_sys/view/user/tasks/taskListDetail.dart';
import 'package:workflow_sys/view/user/teams/teamSettings.dart';

class teamDetail extends StatefulWidget {

  final int teamID;
  final String teamName;
  final bool isAdmin;

  const teamDetail({Key? key, required this.teamID, required this.teamName, required this.isAdmin}) : super(key: key);

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

  Future<TeamDetailReceiver>? futureTeamDetailReceiver;
  UserReceiver? userReceiver;
  String searchKeyword = "";

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

    // replace task list user id with user name (since tasklistUserId is a string)
    for(int i=0; i < teamDetailReceiver.taskList!.length; i++){
      for(int j=0; j < userReceiver!.user!.length; j++){
        if(teamDetailReceiver.taskList![i]!.taskListUserID == userReceiver!.user![j]!.id.toString()){
          teamDetailReceiver.taskList![i]!.taskListUserID = userReceiver!.user![j]!.name;
        }
      }
    }

    setState(() {
      futureTeamDetailReceiver = Future.value(teamDetailReceiver);
      teamName = teamDetailReceiver.team!.teamName!;
    });
    refreshController.refreshCompleted();
  }

  Future<void> getUserData() async {
    UserReceiver? userReceiverData = await getAllUser(context);
    setState(() {
      userReceiver = userReceiverData;
    });
  }

  Future<TeamDetailReceiver> searchList() async {
    TeamDetailReceiver? teamDetailReceiver = await futureTeamDetailReceiver;
    TeamDetailReceiver searchList = TeamDetailReceiver(team: teamDetailReceiver!.team, taskList: []);

    if(searchKeyword == ""){
      searchList = teamDetailReceiver;
    }else{
      for(int i=0; i < teamDetailReceiver.taskList!.length; i++){
        if(teamDetailReceiver.taskList![i]!.taskListUserID!.toLowerCase().contains(searchKeyword.toLowerCase())){
          searchList.taskList!.add(teamDetailReceiver.taskList![i]);
        }
      }
    }

    return searchList;
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
        header: ClassicHeader(),
        onRefresh: getTeamDetailData,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                onChanged: (value){
                  setState(() {
                    searchKeyword = value;
                  });
                  searchList();
                },
              ),
            ),
            FutureBuilder<TeamDetailReceiver>(
              future: searchKeyword=="" ? futureTeamDetailReceiver : searchList(),
              builder: (context, snapshot){
                if(snapshot.hasError) print(snapshot.error);

                if(snapshot.hasData){
                  return teamItem(teamDetailReceiver: snapshot.data!, userReceiver: userReceiver!);
                }else{
                  return Center(child: CupertinoActivityIndicator(radius: 12));
                }
              },
            ),
          ],
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

  const teamItem({Key? key, required this.teamDetailReceiver, required this.userReceiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: teamDetailReceiver.taskList!.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
            HapticFeedback.lightImpact();
            // taskListUserID contains username. Therefore, convert back to userID using userName
            int taskListUserIDTemp = convertUserNameToUserID(teamDetailReceiver.taskList![index]!.taskListUserID!)!;
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (_){
                      return taskHome(userReceiver: userReceiver, teamID: teamDetailReceiver.team!.id!, taskListID: teamDetailReceiver.taskList![index]!.id!, taskListUserID: taskListUserIDTemp ,taskListUserName: teamDetailReceiver.taskList![index]!.taskListUserID!);
                    }
                )
            );
          },
          child: Card(
            child: AwesomeListItem(
              image: serverURL + '/' + userReceiver.userDetail![index]!.userDetailProfilePictureDir!,
              title: teamDetailReceiver.taskList![index]!.taskListUserID! + "'s Task List",
              content: '',
            ),
          ),
        );
      },
    );
  }

  // unused code
  String? convertUserIDtoName(String userID){
    for(int i=0; i < userReceiver.user!.length; i++){
      if(userID == userReceiver.user![i]!.id.toString()){
        return userReceiver.user![i]!.name!;
      }
    }
  }

  int? convertUserNameToUserID(String userName){
    for(int i=0; i < userReceiver.user!.length; i++){
      if(userName == userReceiver.user![i]!.name){
        return userReceiver.user![i]!.id!;
      }
    }
  }
}

