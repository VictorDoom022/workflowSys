import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/User.dart';

class selectMember extends StatefulWidget {

  // type 1 = add member to team
  // type 2 = remove member from team
  // type 3 = view only

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

  int userListLength;
  List<bool> isChecked = [];
  List<int> selectedUserListID = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      userListLength = userList.length;
      isChecked = List<bool>.generate(userListLength, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Select member'),
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
            }
          },
        ),
      ),
      body: ListView.builder(
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
      ),
    );
  }

}
