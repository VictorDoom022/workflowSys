import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/selectors/selectMember.dart';

class teamSettingsPage extends StatefulWidget {

  final int teamID;
  final bool isAdmin;

  const teamSettingsPage({Key? key, required this.teamID, required this.isAdmin}) : super(key: key);

  @override
  _teamSettingsPageState createState() => _teamSettingsPageState(teamID, isAdmin);
}

class _teamSettingsPageState extends State<teamSettingsPage> {

  final int teamID;
  final bool isAdmin;

  _teamSettingsPageState(this.teamID, this.isAdmin);

  late int currentLoggedInUserID;
  GlobalKey<ScaffoldState> teamSettingsScaffoldKey = GlobalKey();
  TextEditingController renameTeamController = TextEditingController();

  Future<TeamDetailReceiver>? futureTeamDetailReceiver;

  @override
  void initState() {
    getCurrentLoggedInUserID();
  }

  void getCurrentLoggedInUserID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? userID = sharedPreferences.getInt("UserID");

    setState(() {
      currentLoggedInUserID = userID!;
    });
  }

  Future<List<User>> getUserJoinedTeamList() async {
    List<User> userList = await getUserJoinedTeam(teamID);

    return userList;
  }

  Future<List<User>> getUserNotJoinedTeamList() async {
    TeamDetailReceiver teamDetailReceiver = await getTeamDetail(teamID);
    List<User>? userList = await getUserNotJoinedTeam(int.parse(teamDetailReceiver.team!.teamGroupID!), teamID);

    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Team settings'),
      ),
      body: SettingsList(
        contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        sections: [
          SettingsSection(
            title: Text('General'),
            tiles: [
              SettingsTile(
                title: Text('View members'),
                onPressed: (_) {
                  viewMember();
                },
              )
            ],
          ),
          SettingsSection(
            title: Text('Admin section'),
            tiles: [
              SettingsTile(
                title: Text('Add new member'),
                enabled: isAdmin,
                onPressed: (_){
                  addNewMember();
                },
              ),
              SettingsTile(
                title: Text('Remove member'),
                enabled: isAdmin,
                onPressed: (_){
                  removeMember();
                },
              ),
              SettingsTile(
                title: Text('Rename team'),
                enabled: isAdmin,
                // iosChevron: null,
                onPressed: (_){
                  renameTeamSection();
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Danger zone'),
            tiles: [
              SettingsTile(
                title: Text('Delete team'),
                enabled: isAdmin,
                // iosChevron: null,
                onPressed: (_){
                  deleteTeamSection();
                },
              ),
              SettingsTile(
                title: Text('Quit team'),
                // iosChevron: null,
                onPressed: (_){
                  quitTeam();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  void viewMember(){
    LoadingScreen.showLoadingScreen(context, teamSettingsScaffoldKey);
    getUserJoinedTeamList().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 3, teamID: teamID, userList: value);
          })
      );
    });
  }

  void addNewMember(){
    LoadingScreen.showLoadingScreen(context, teamSettingsScaffoldKey);
    getUserNotJoinedTeamList().then((value) {
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 1, teamID: teamID, userList: value);
          })
      );
    });
  }

  void removeMember(){
    LoadingScreen.showLoadingScreen(context, teamSettingsScaffoldKey);
    getUserJoinedTeamList().then((value) {
      for(int i=0; i < value.length; i++){
        if(value[i].id == currentLoggedInUserID){
          value.removeAt(i);
        }
      }
      Navigator.of(context).pop();
      Navigator.push(
          context,
          CupertinoPageRoute(builder: (context){
            return selectMember(type: 2, teamID: teamID, userList: value);
          })
      );
    });
  }

  void renameTeamSection(){
    showDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Text(
                  'New team name',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 5),
                CupertinoTextField(
                  controller: renameTeamController,
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
                  if(renameTeamController.text.isNotEmpty){
                    LoadingScreen.showLoadingScreen(context, teamSettingsScaffoldKey);
                    renameTeam(context, teamID, renameTeamController.text).then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    });
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Team name cannot be empty')));
                  }
                },
              )
            ],
          );
        }
    );
  }

  void deleteTeamSection(){
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
                  LoadingScreen.showLoadingScreen(context, teamSettingsScaffoldKey);
                  deleteTeam(context, teamID).then((value) {
                    Navigator.of(context).pop();
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
  }

  void quitTeam(){
    showDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            content: Text(
              'Are you sure you want to quit this team?',
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
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  List<int> userList = [];

                  int? userID = sharedPreferences.getInt("UserID");
                  userList.add(userID!);

                  removeMemberFromTeam(context, teamID, userList).then((value) {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          );
        }
    );
  }
}
