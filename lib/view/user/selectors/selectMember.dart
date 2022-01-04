import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/taskController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/view/user/profile/userInfo.dart';
import 'package:workflow_sys/controller/setupDir.dart';

class selectMember extends StatefulWidget {

  // type 1 = add member to team
  // type 2 = remove member from team
  // type 3 = view only
  // type 4 = add member as admin (teamID = groupID since serve the same purpose)
  // type 5 = remove admin (teamID = groupID since serve the same purpose)
  // type 6 = assign task to member (teamID = taskID) can select one only
  // type 7 = remove member from group (teamID = groupID since serve the same purpose)

  final int type;
  final int? teamID;
  final List<User> userList;

  const selectMember({Key? key, required this.type, this.teamID, required this.userList}) : super(key: key);

  @override
  _selectMemberState createState() => _selectMemberState(type, teamID, userList);
}

class _selectMemberState extends State<selectMember> {

  final int type;
  final int? teamID;
  final List<User> userList;

  _selectMemberState(this.type, this.teamID, this.userList);

  String appTitle = "Select member";
  int? userListLength;
  List<bool> isChecked = [];
  List<int> selectedUserListID = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAppTitle();
    setState(() {
      userListLength = userList.length;
      isChecked = List<bool>.generate(userListLength!, (index) => false);
    });
  }

  void setAppTitle(){
    String? appTitleSet;
    switch (type) {
      case 1:
        appTitleSet = 'Select a member to add';
        break;
      case 2:
        appTitleSet = 'Select a member to remove';
        break;
      case 3:
        appTitleSet = 'Member list';
        break;
      case 4:
        appTitleSet = 'Select member as admin';
        break;
      case 5:
        appTitleSet = 'Select member to remove from admin';
        break;
      case 6:
        appTitleSet = 'Assign task to team member';
        break;
      case 7:
        appTitleSet = 'Select member to remove from group';
        break;
    }

    setState(() {
      appTitle = appTitleSet!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(appTitle),
        trailing: CupertinoButton(
          padding: const EdgeInsets.all(0.0),
          child: Text('Done'),
          onPressed: () async {
            if(type == 1){
              addMemberToTeam(context, teamID!, selectedUserListID).then((value) {
                Navigator.of(context).pop();
              });
            }else if(type == 2){
              removeMemberFromTeam(context, teamID!, selectedUserListID).then((value) {
                Navigator.of(context).pop();
              });
            }else if(type == 3){
              Navigator.of(context).pop();
            }else if(type == 4){
              setMemberAsAdmin(context, teamID!, selectedUserListID).then((value){
                Navigator.of(context).pop();
              });
            }else if(type == 5){
              removeMemberFromGroupAdmin(context, teamID!, selectedUserListID).then((value) {
                Navigator.of(context).pop();
              });
            }else if(type == 6){
              if(selectedUserListID.length == 1){
                assignTask(context, teamID!, selectedUserListID[0]).then((value) {
                  Navigator.of(context).pop();
                });
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You can only select one member')));
              }
            }else if(type == 7){
              removeMemberFromGroup(context, teamID!, selectedUserListID).then((value) {
                Navigator.of(context).pop();
              });
            }
          },
        ),
      ),
      body: userList.length != 0 ?ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: userList.length,
          itemBuilder: (context, index){
            return type != 3 ? GFCheckboxListTile(
              activeBgColor: Colors.green,
              type: GFCheckboxType.circle,
              avatar: FutureBuilder(
                initialData: 'upload/userProfilePictures/userProfilePic.jpg',
                future: getUserProfilePictureByUserID(userList[index].id!),
                builder: (context, snapshot){
                  return GFAvatar(
                      // radius: 50,
                      backgroundImage: NetworkImage(serverURL + '/' + snapshot.data.toString())
                  );
                },
              ),
                title: Text(
                  userList[index].name!,
                ),
                value: isChecked[index],
                onChanged: (bool){
                  setState(() {
                    isChecked[index] = bool;
                    if(isChecked[index] == true){
                      selectedUserListID.add(userList[index].id!);
                    }else{
                      selectedUserListID.remove(userList[index].id);
                    }
                  });
                }
            ) : ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: FutureBuilder(
                initialData: 'upload/userProfilePictures/userProfilePic.jpg',
                future: getUserProfilePictureByUserID(userList[index].id!),
                builder: (context, snapshot){
                  return CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(serverURL + '/' + snapshot.data.toString())
                  );
                },
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userList[index].name!,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onTap: (){
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_){
                        return userInfo(userID: userList[index].id!);
                    }
                  )
                );
              },
            );
          }
      ) : Center(child: Text('No members')),
    );
  }

}
