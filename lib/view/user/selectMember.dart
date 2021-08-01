import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/model/User.dart';

class selectMember extends StatefulWidget {

  final List<User> userList;

  const selectMember({Key key, this.userList}) : super(key: key);

  @override
  _selectMemberState createState() => _selectMemberState(userList);
}

class _selectMemberState extends State<selectMember> {

  final List<User> userList;

  _selectMemberState(this.userList);

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
            print(selectedUserListID.length);
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
