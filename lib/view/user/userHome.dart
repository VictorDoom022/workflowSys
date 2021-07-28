import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/model/Group.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class userHome extends StatefulWidget {
  const userHome({Key key}) : super(key: key);

  @override
  _userHomeState createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {

  GlobalKey<ScaffoldState> userHomeScaffoldKey = GlobalKey();
  TextEditingController createGroupNameController = TextEditingController();
  ButtonStyle createGroupButtonStyle = ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
          )
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
          TextStyle(
            fontSize: 18,
          )
      )
  );

  Future<List<Group>> futureGroupList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupListData();
  }

  Future<void> getGroupListData() async {
    List<Group> listGroup = await getUserJoinedGroup();
    setState(() {
      futureGroupList = Future.value(listGroup);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userHomeScaffoldKey,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            HapticFeedback.lightImpact();
            userHomeScaffoldKey.currentState.openDrawer();
          },
        ),
        middle: Text('Home'),
        trailing: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.refresh),
          onPressed: (){
            HapticFeedback.lightImpact();
            getGroupListData().then((value){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Refreshed')));
            });
          },
        ),
      ),
      drawer: userNavDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: [
            createGroupButton(),
            Expanded(
              child: FutureBuilder<List<Group>>(
                future: futureGroupList,
                builder: (context, snapshot){
                  if(snapshot.hasError) print(snapshot.error);

                  if(snapshot.hasData){
                    return groupItem(listGroup: snapshot.data);
                  }else{
                    return Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Center(child: CupertinoActivityIndicator(radius: 12)),
                    );
                  }
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createGroupButton(){
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        child: Text('Create new group'),
        style: createGroupButtonStyle,
        onPressed: (){
          showDialog(
              context: context,
              builder: (_){
                return CupertinoAlertDialog(
                  content: Column(
                    children: [
                      Text(
                        'Group name',
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: 5),
                      CupertinoTextField(
                        controller: createGroupNameController,
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
                        createGroup(context, createGroupNameController.text);
                        Navigator.of(
                            context,
                            rootNavigator: true
                        ).pop();
                      },
                    )
                  ],
                );
              }
          );
        },
      ),
    );
  }
}

class groupItem extends StatelessWidget {

  final List<Group> listGroup;

  const groupItem({Key key, this.listGroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listGroup.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(listGroup[index].groupName),
        );
      }
    );
  }
}

