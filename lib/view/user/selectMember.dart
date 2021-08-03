import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/User.dart';

class selectMember extends StatefulWidget {

  // type 1 = add member to team
  // type 2 = remove member from team
  // type 3 = view only
  // type 4 = add member as admin (teamID = groupID since serve the same purpose)
  // type 5 = remove admin (teamID = groupID since serve the same purpose)

  final int type;
  final int teamID;
  final List<User> userList;

  const selectMember({Key key, this.type, this.teamID, this.userList}) : super(key: key);

  @override
  _selectMemberState createState() => _selectMemberState(type, teamID, userList);
}

class _selectMemberState extends State<selectMember> {

  final int type;
  final int teamID;
  final List<User> userList;

  _selectMemberState(this.type, this.teamID, this.userList);

  String appTitle = "Select member";
  int userListLength;
  List<bool> isChecked = [];
  List<int> selectedUserListID = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAppTitle();
    setState(() {
      userListLength = userList.length;
      isChecked = List<bool>.generate(userListLength, (index) => false);
    });
  }

  void setAppTitle(){
    String appTitleSet;
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
    }

    setState(() {
      appTitle = appTitleSet;
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
          onPressed: (){
            if(type == 1){
              addMemberToTeam(context, teamID, selectedUserListID).then((value) {
                Navigator.of(context).pop();
              });
            }else if(type == 2){
              removeMemberFromTeam(context, teamID, selectedUserListID).then((value) {
                Navigator.of(context).pop();
              });
            }else if(type == 3){
              Navigator.of(context).pop();
            }else if(type == 4){
              setMemberAsAdmin(context, teamID, selectedUserListID).then((value){
                Navigator.of(context).pop();
              });
            }else if(type == 5){
              removeMemberFromGroupAdmin(context, teamID, selectedUserListID).then((value) {
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
            return type != 3 ? CheckboxListTile(
                title: Text(userList[index].name),
                value: isChecked[index],
                onChanged: (bool){
                  setState(() {
                    isChecked[index] = bool;
                    if(isChecked[index] == true){
                      selectedUserListID.add(userList[index].id);
                    }else{
                      selectedUserListID.remove(userList[index].id);
                    }
                  });
                }
            ) : ListTile(
              title: Text(userList[index].name),
            );
          }
      ) : Center(child: Text('No members')),
    );
  }

}
