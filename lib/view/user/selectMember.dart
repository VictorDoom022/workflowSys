import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/User.dart';

class selectMember extends StatefulWidget {

  final int teamID;
  final List<User> userList;

  const selectMember({Key key, this.teamID, this.userList}) : super(key: key);

  @override
  _selectMemberState createState() => _selectMemberState(teamID, userList);
}

class _selectMemberState extends State<selectMember> {

  final int teamID;
  final List<User> userList;

  _selectMemberState(this.teamID, this.userList);

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
            addMemberToTeam(context, teamID, selectedUserListID).then((value) {
              Navigator.of(context).pop();
            });
          },
        ),
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: userList.length,
          itemBuilder: (context, index){
            return CheckboxListTile(
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
            );
          }
      ),
    );
  }

}
