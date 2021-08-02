import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/GroupDetailReceiver.dart';
import 'package:workflow_sys/model/Team.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/selectTeam.dart';
import 'package:workflow_sys/view/user/teamDetail.dart';

class groupDetail extends StatefulWidget {

  final int groupID;
  final String groupName;

  const groupDetail({Key key, this.groupID, this.groupName}) : super(key: key);

  @override
  _groupDetailState createState() => _groupDetailState(groupID, groupName);
}

class _groupDetailState extends State<groupDetail> {

  final int groupID;
  final String groupName;

  _groupDetailState(this.groupID, this.groupName);

  GlobalKey<ScaffoldState> groupDetailScaffoldKey = GlobalKey();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  TextEditingController teamNameController = TextEditingController();

  Future<GroupDetailReceiver> futureGroupDetailReceiver;
  bool userAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupDetailData();
  }

  Future<void> getGroupDetailData() async {
    GroupDetailReceiver groupDetailReceiver = await getGroupDetailByGroupUserID(groupID);
    checkUserAdmin(groupDetailReceiver);
    setState(() {
      futureGroupDetailReceiver = Future.value(groupDetailReceiver);
    });
    refreshController.refreshCompleted();
  }

  Future<List<Team>> getAllGroupTeam() async {
    List<Team> teamList = await getGroupTeamByGroupID(groupID);

    return teamList;
  }

  void checkUserAdmin(GroupDetailReceiver groupDetailReceiver) async {
    String adminList = groupDetailReceiver.group.groupAdminList;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int userID = sharedPreferences.getInt("UserID");

    List<String> adminArrList = adminList.split(',');

    for(int i=0; i < adminArrList.length; i++){
      if(adminArrList[i] == userID.toString()){
        setState(() {
          userAdmin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('group ($groupName)'),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.more_vert),
          onPressed: (){
            showCupertinoModalPopup(
                context: context,
                builder: (_){
                  return CupertinoActionSheet(
                    title: Text('Choose an action'),
                    actions: [
                      CupertinoActionSheetAction(
                        child: Text('View all teams'),
                        onPressed: (){
                          LoadingScreen.showLoadingScreen(context, groupDetailScaffoldKey);
                          getAllGroupTeam().then((value) {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context){
                                return selectTeam(type: 1, teamList: value);
                              })
                            );
                          });
                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Text('Set member admin'),
                        onPressed: (){

                        },
                      ),
                      CupertinoActionSheetAction(
                        child: Text('View all members'),
                        onPressed: (){

                        },
                      ),
                    ],
                  );
                }
            );
          },
        ),
      ),
      floatingActionButton: userAdmin==true ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          createTeamDialog();
        },
      ) : null,
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        header: BezierCircleHeader(),
        onRefresh: getGroupDetailData,
        child: FutureBuilder<GroupDetailReceiver>(
          future: futureGroupDetailReceiver,
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);

            if(snapshot.hasData){
              return groupItem(isAdmin: userAdmin, groupDetailReceiver: snapshot.data);
            }else{
              return Center(child: CupertinoActivityIndicator(radius: 12));
            }
          },
        ),
      ),
    );
  }

  Future<dynamic> createTeamDialog(){
    return showDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Text(
                  'Team Name',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 5),
                CupertinoTextField(
                  controller: teamNameController,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: (){
                  HapticFeedback.lightImpact();
                  Navigator.of(
                      context,
                      rootNavigator: true
                  ).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Create',
                  style: TextStyle(
                      color: Colors.blue
                  ),
                ),
                onPressed: (){
                  HapticFeedback.lightImpact();
                  createTeam(context, groupID, teamNameController.text);
                  Navigator.of(
                      context,
                      rootNavigator: true
                  ).pop();
                  getGroupDetailData();
                },
              )
            ],
          );
        }
    );
  }
}

class groupItem extends StatelessWidget {

  final GroupDetailReceiver groupDetailReceiver;
  final bool isAdmin;

  const groupItem({Key key, this.groupDetailReceiver, this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<ScaffoldState> groupItemScaffoldKey = GlobalKey();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: groupDetailReceiver.team.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(groupDetailReceiver.team[index].teamName),
          onTap: (){
            HapticFeedback.lightImpact();
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder:(context){
                      return teamDetail(isAdmin: isAdmin, teamID: groupDetailReceiver.team[index].id, teamName: groupDetailReceiver.team[index].teamName);
                    }
                )
            );
          },
          onLongPress: (){
            showCupertinoModalPopup(
              context: context,
              builder: (_){
                return CupertinoActionSheet(
                  title: Text('Choose an action'),
                  actions: [
                    CupertinoActionSheetAction(
                      child: Text('Delete Team'),
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (_){
                              return CupertinoAlertDialog(
                                content: Text(
                                  'Are you sure you want to delete this?',
                                  style: TextStyle(
                                      fontSize: 20
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: (){
                                      HapticFeedback.lightImpact();
                                      Navigator.of(
                                          context,
                                          rootNavigator: true
                                      ).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.blue
                                      ),
                                    ),
                                    onPressed: () async {
                                      HapticFeedback.lightImpact();
                                      LoadingScreen.showLoadingScreen(context, groupItemScaffoldKey);
                                      deleteTeam(context, groupDetailReceiver.team[index].id).then((value) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      });
                                    },
                                  )
                                ],
                              );
                            }
                        );
                      },
                    )
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
          },
        );
      }
    );
  }
}

