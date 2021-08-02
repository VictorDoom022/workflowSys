import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/Team.dart';
import 'package:workflow_sys/view/misc/loadingScreen.dart';
import 'package:workflow_sys/view/user/teamDetail.dart';

class selectTeam extends StatefulWidget {

  // type 1 = view only

  final int type;
  final List<Team> teamList;

  const selectTeam({Key key, this.type, this.teamList}) : super(key: key);

  @override
  _selectTeamState createState() => _selectTeamState(type, teamList);
}

class _selectTeamState extends State<selectTeam> {

  final int type;
  final List<Team> teamList;

  GlobalKey<ScaffoldState> selectTeamScaffoldKey = GlobalKey();

  _selectTeamState(this.type, this.teamList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Team List'),
        trailing: CupertinoButton(
          padding: const EdgeInsets.all(0.0),
          child: Text('Done'),
          onPressed: (){
            if(type == 1){
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: teamList.length,
          itemBuilder: (context, index){
            return ListTile(
              title: Text(teamList[index].teamName),
              onTap: (){
                HapticFeedback.lightImpact();
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context){
                      return teamDetail(isAdmin: true, teamName: teamList[index].teamName, teamID: teamList[index].id);
                    })
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
                                            LoadingScreen.showLoadingScreen(context, selectTeamScaffoldKey);
                                            deleteTeam(context, teamList[index].id).then((value) {
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
      ),
    );
  }
}
