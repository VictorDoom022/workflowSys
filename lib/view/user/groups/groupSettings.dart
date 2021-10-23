import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/model/Team.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/selectors/selectMember.dart';
import 'package:workflow_sys/view/user/selectors/selectTeam.dart';

class groupSettingsPage extends StatefulWidget {

  final int groupID;
  final bool isAdmin;

  const groupSettingsPage({Key? key, required this.groupID, required this.isAdmin}) : super(key: key);

  @override
  _groupSettingsPageState createState() => _groupSettingsPageState(groupID, isAdmin);
}

class _groupSettingsPageState extends State<groupSettingsPage> {

  final int groupID;
  final bool isAdmin;
  
  _groupSettingsPageState(this.groupID, this.isAdmin);

  GlobalKey<ScaffoldState> groupSettingsScaffoldKey = GlobalKey();
  TextEditingController renameGroupController = TextEditingController();

  Future<List<User>> getGroupUser() async {
    List<User> userList = await getGroupUserByGroupID(groupID);

    return userList;
  }

  Future<List<User>> getGroupAdminUser() async {
    List<User> userList = await getGroupAdminUserList(groupID);

    return userList;
  }

  Future<List<Team>> getAllGroupTeam() async {
    List<Team> teamList = await getGroupTeamByGroupID(groupID);

    return teamList;
  }

  Future<List<User>> getGroupNonAdminUser() async {
    List<User> userList = await getGroupNonAdminUserList(groupID);

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Group settings'),
      ),
      body: SettingsList(
        contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        sections: [
          SettingsSection(
            title: 'General',
            tiles: [
              SettingsTile(
                title: 'View all members',
                onPressed: (_){
                  viewAllMembers();
                },
              ),
              SettingsTile(
                title: 'View group admin',
                onPressed: (_){
                  viewGroupAdmin();
                },
              )
            ],
          ),
          SettingsSection(
            title: 'Admin section',
            tiles: [
              SettingsTile(
                title: 'Generate new join code',
                enabled: isAdmin,
                iosChevron: null,
                onPressed: (_){
                  generateNewJoinCode();
                },
              ),
              SettingsTile(
                title: 'Rename group',
                enabled: isAdmin,
                iosChevron: null,
                onPressed: (_){
                  renameGroupSection();
                },
              ),
              SettingsTile(
                title: 'View all teams',
                enabled: isAdmin,
                onPressed: (_){
                  viewAllTeams();
                },
              ),
              SettingsTile(
                title: 'Set member as admin',
                enabled: isAdmin,
                onPressed: (_){
                  setMemberAsAdmin();
                },
              ),
              SettingsTile(
                title: 'Remove admin',
                enabled: isAdmin,
                onPressed: (_){
                  removeAdmin();
                },
              ),
              SettingsTile(
                title: 'Remove member from group',
                enabled: isAdmin,
                onPressed: (_){
                  removeMemberFromGroupSection();
                },
              ),
            ],
          ),
          SettingsSection(
            title: 'Danger zone',
            tiles: [
              SettingsTile(
                title: 'Leave group',
                iosChevron: null,
                onPressed: (_){
                  leaveGroup();
                },
              ),
              SettingsTile(
                title: 'Delete group',
                enabled: isAdmin,
                iosChevron: null,
                onPressed: (_){
                  deleteGroupSection();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void viewAllMembers(){
    LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
    getGroupUser().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 3, userList: value);
          })
      );
    });
  }

  void viewGroupAdmin(){
    LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
    getGroupAdminUser().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 3, userList: value, teamID: groupID);
          })
      );
    });
  }

  void generateNewJoinCode(){
    LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
    generateNewGroupJoinCode(context, groupID).then((value){
      Navigator.of(context).pop();
    });
  }

  void renameGroupSection(){
    showDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Text(
                  'New group name',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 5),
                CupertinoTextField(
                  controller: renameGroupController,
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
                  'Rename',
                  style: TextStyle(
                      color: Colors.blue
                  ),
                ),
                onPressed: (){
                  HapticFeedback.lightImpact();
                  LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
                  renameGroup(context, groupID, renameGroupController.text).then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        }
    );
  }

  void viewAllTeams(){
    LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
    getAllGroupTeam().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectTeam(type: 1, teamList: value);
          })
      );
    });
  }

  void setMemberAsAdmin(){
    LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
    getGroupNonAdminUser().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 4, userList: value, teamID: groupID);
          })
      );
    });
  }

  void removeAdmin(){
    LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
    getGroupAdminUser().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 5, userList: value, teamID: groupID);
          })
      );
    });
  }

  void removeMemberFromGroupSection(){
    LoadingScreen.showLoadingScreen(context, groupSettingsScaffoldKey);
    getGroupUser().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 7, userList: value, teamID: groupID);
          })
      );
    });
  }

  void deleteGroupSection(){
    showDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            content: Text('Are you sure you want to delete this group?'),
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
                  'Delete',
                  style: TextStyle(
                      color: Colors.blue
                  ),
                ),
                onPressed: (){
                  HapticFeedback.lightImpact();
                  deleteGroup(context, groupID);
                },
              )
            ],
          );
        }
    );
  }

  void leaveGroup(){
    showDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            content: Text('Are you sure you want to leave this group?'),
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
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  List<int> userList = [];

                  int? userID = sharedPreferences.getInt("UserID");
                  userList.add(userID!);

                  removeMemberFromGroup(context, groupID, userList).then((value){
                    Navigator.popAndPushNamed(context, '/userHome');
                  });
                },
              )
            ],
          );
        }
    );
  }
}
