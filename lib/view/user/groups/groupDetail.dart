import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/GroupDetailReceiver.dart';
import 'package:workflow_sys/model/Team.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/groups/groupSettings.dart';
import 'package:workflow_sys/view/user/selectors/selectMember.dart';
import 'package:workflow_sys/view/user/selectors/selectTeam.dart';
import 'package:workflow_sys/view/user/teams/teamDetail.dart';

class groupDetail extends StatefulWidget {

  final int? groupID;
  final String? groupName;

  const groupDetail({Key? key, this.groupID, this.groupName}) : super(key: key);

  @override
  _groupDetailState createState() => _groupDetailState(groupID!, groupName!);
}

class _groupDetailState extends State<groupDetail> {

  final int groupID;
  String groupName;

  _groupDetailState(this.groupID, this.groupName);

  GlobalKey<ScaffoldState> groupDetailScaffoldKey = GlobalKey();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  TextEditingController teamNameController = TextEditingController();

  Future<GroupDetailReceiver>? futureGroupDetailReceiver;
  bool userAdmin = false;
  String groupJoinCode = "";
  String searchKeyWord = "";

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
      groupJoinCode = groupDetailReceiver.group!.groupJoinCode!;
      groupName = groupDetailReceiver.group!.groupName!;
    });
    refreshController.refreshCompleted();
  }

  Future<GroupDetailReceiver> searchList() async{
    GroupDetailReceiver? groupDetailReceiver = await futureGroupDetailReceiver;
    GroupDetailReceiver searchList = GroupDetailReceiver(group: groupDetailReceiver!.group, team: []);

    if(searchKeyWord == ""){
      searchList = groupDetailReceiver;
    }else{
      for(int i=0; i< groupDetailReceiver.team!.length; i++){
        if(groupDetailReceiver.team![i]!.teamName!.toLowerCase().contains(searchKeyWord)){
          searchList.team!.add(groupDetailReceiver.team![i]);
        }
      }
    }

    return searchList;
  }

  void checkUserAdmin(GroupDetailReceiver groupDetailReceiver) async {
    String? adminList = groupDetailReceiver.group!.groupAdminList;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? userID = sharedPreferences.getInt("UserID");

    List<String> adminArrList = adminList!.split(',');

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
                        child: Text('Settings'),
                        onPressed: (){
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context){
                                return groupSettingsPage(groupID: groupID, isAdmin: userAdmin);
                              })
                          ).then((value) {
                            getGroupDetailData();
                          });
                        },
                      ),
                      userAdmin== true ? CupertinoActionSheetAction(
                        child: Text('Show join code'),
                        onPressed: (){
                          showCupertinoDialog(
                              context: context,
                              builder: (context){
                                return CupertinoAlertDialog(
                                  title: Text('Join code'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Here's your join code for " + groupName),
                                      Text(
                                        groupJoinCode,
                                        style: TextStyle(
                                            fontSize: 17
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text('Close'),
                                      onPressed: (){
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text('Copy'),
                                      onPressed: (){
                                        Clipboard.setData(ClipboardData(text: groupJoinCode));
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Copied!')));
                                      },
                                    ),
                                  ],
                                );
                              }
                          );
                        },
                      ) : Container(),
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
        header: ClassicHeader(),
        onRefresh: getGroupDetailData,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoSearchTextField(
                onChanged: (value){
                  setState(() {
                    searchKeyWord = value;
                  });
                  searchList();
                },
              ),
            ),
            FutureBuilder<GroupDetailReceiver>(
              future: searchKeyWord=="" ? futureGroupDetailReceiver : searchList(),
              builder: (context, snapshot){
                if(snapshot.hasError) print(snapshot.error);

                if(snapshot.hasData){
                  return groupItem(isAdmin: userAdmin, groupDetailReceiver: snapshot.data!);
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
                  if(teamNameController.text.isNotEmpty){
                    createTeam(context, groupID, teamNameController.text);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Team name cannot be empty.')));
                  }
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

  const groupItem({Key? key, required this.groupDetailReceiver, required this.isAdmin}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    GlobalKey<ScaffoldState> groupItemScaffoldKey = GlobalKey();

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: groupDetailReceiver.team!.length,
      itemBuilder: (context, index){
        return Card(
          elevation: 8.0,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            title: Text(
                groupDetailReceiver.team![index]!.teamName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300
              ),
            ),
            onTap: (){
              HapticFeedback.lightImpact();
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder:(context){
                        return teamDetail(isAdmin: isAdmin, teamID: groupDetailReceiver.team![index]!.id!, teamName: groupDetailReceiver.team![index]!.teamName!);
                      }
                  )
              );
            },
          ),
        );
      }
    );
  }
}

