import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/model/Group.dart';
import 'package:workflow_sys/view/user/groups/groupDetail.dart';
import 'package:workflow_sys/view/user/userNavDrawer.dart';

class userHome extends StatefulWidget {
  const userHome({Key key}) : super(key: key);

  @override
  _userHomeState createState() => _userHomeState();
}

class _userHomeState extends State<userHome> {

  GlobalKey<ScaffoldState> userHomeScaffoldKey = GlobalKey();
  TextEditingController createGroupNameController = TextEditingController();
  TextEditingController joinGroupCodeController = TextEditingController();
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
    List<Group> listGroup = await getUserJoinedGroup(context);
    setState(() {
      futureGroupList = Future.value(listGroup);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: userHomeScaffoldKey,
      drawer: userNavDrawer(),
      body: DraggableHome(
        alwaysShowLeadingAndAction: true,
        curvedBodyRadius: 5.0,
        leading: IconButton(
          icon: Icon(
              Icons.list,
              color: Colors.white,
          ),
          onPressed: (){
            HapticFeedback.lightImpact();
            userHomeScaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(
            'Groups',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (_){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('Join Group'),
                        onTap: joinGroupDialog,
                      ),
                      ListTile(
                        title: Text('Create Group'),
                        onTap: createTeamDialog,
                      ),
                    ],
                  );
                }
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
                Icons.refresh,
              color: Colors.white,
            ),
            onPressed: (){
              HapticFeedback.lightImpact();
              getGroupListData().then((value){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Refreshed')));
              });
            },
          ),
        ],
        headerWidget: Container(
          child: Center(
            child: Text(
                'Groups',
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        body: [
          FutureBuilder<List<Group>>(
              future: futureGroupList,
              builder: (context, snapshot){
                if(snapshot.hasError) print(snapshot.error);

                if(snapshot.hasData){
                  if(snapshot.data.toString() != "[]"){
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index){
                          return Card(
                            elevation: 8.0,
                            child: Container(
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                title: Text(
                                  snapshot.data[index].groupName,
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
                                            return groupDetail(groupID: snapshot.data[index].id, groupName: snapshot.data[index].groupName);
                                          }
                                      )
                                  ).then((value) {
                                    getGroupListData();
                                  });
                                },
                              ),
                            ),
                          );
                        }
                    );
                  }else{
                    return Center(child: Text('No groups joined'));
                  }
                }else{
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Center(child: CupertinoActivityIndicator(radius: 12)),
                  );
                }
              }
          ),
        ],
      ),
    );
  }


  Future<dynamic> joinGroupDialog(){
    return showDialog(
        context: context,
        builder: (_){
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Text(
                  'Join code',
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 5),
                CupertinoTextField(
                  controller: joinGroupCodeController,
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
                  'Join',
                  style: TextStyle(
                      color: Colors.blue
                  ),
                ),
                onPressed: (){
                  HapticFeedback.lightImpact();
                  joinGroup(context, joinGroupCodeController.text);
                  Navigator.of(
                      context,
                      rootNavigator: true
                  ).pop();
                  getGroupListData();
                },
              )
            ],
          );
        }
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
                  getGroupListData();
                },
              )
            ],
          );
        }
    );
  }
}
