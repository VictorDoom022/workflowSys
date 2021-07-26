import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workflow_sys/controller/userController.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserReceiver.dart';
import 'package:workflow_sys/view/admin/adminNavDrawer.dart';
import 'package:workflow_sys/view/admin/adminUserDetail.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class adminHome extends StatefulWidget {
  const adminHome({Key key}) : super(key: key);

  @override
  _adminHomeState createState() => _adminHomeState();
}

class _adminHomeState extends State<adminHome> {

  GlobalKey<ScaffoldState> adminHomeScaffoldKey = GlobalKey();

  Future<UserReceiver> futureUserReceiver;

  void initState(){
    super.initState();
    getUserData();
  }

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<void> getUserData() async{
    UserReceiver userReceiver = await getAllUser();
    setState(() {
      futureUserReceiver = Future.value(userReceiver);
    });
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: adminHomeScaffoldKey,
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Icon(Icons.list),
          onPressed: (){
            HapticFeedback.lightImpact();
            adminHomeScaffoldKey.currentState.openDrawer();
          },
        ),
        middle: Text('Home'),
      ),
      drawer: adminNavDrawer(),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        header: BezierCircleHeader(),
        onRefresh: getUserData,
        child: FutureBuilder<UserReceiver>(
          future: futureUserReceiver,
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);

            if(snapshot.hasData){
              return userItem(users: snapshot.data);
            }else{
              return Center(child: CupertinoActivityIndicator(radius: 12));
            }
          },
        ),
      ),
    );
  }
}

class userItem extends StatelessWidget {

  final UserReceiver users;

  const userItem({Key key, this.users}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextEditingController userDetailController = TextEditingController();

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: users.user.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onLongPress: (){
              userActionOptionPopup(context, userDetailController, users.user[index].id, users.userDetail[index].userDetailStatus, users.userDetail[index].userDetailAccEnable);
            },
            child: ListTile(
              title: Text(users.user[index].name),
              subtitle: Text(users.user[index].email),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder:(context){
                        return adminUserDetail(user: users.user[index], userDetail: users.userDetail[index]);
                      }
                    )
                );
              },
            ),
          );
        }
    );
  }

  Future<dynamic> userActionOptionPopup(BuildContext context, TextEditingController userDetailController, int userID, String userStatus, int userAccEnable){

    userDetailController = TextEditingController(text: userStatus);

    return showCupertinoModalPopup(
        context: context,
        builder: (_){
          return CupertinoActionSheet(
            title: Text('Choose an action'),
            actions: [
              CupertinoActionSheetAction(
                child: Text('Edit Status'),
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (_){
                        return CupertinoAlertDialog(
                          content: Column(
                            children: [
                              Text(
                                'User Status',
                                style: TextStyle(
                                    fontSize: 20
                                ),
                              ),
                              SizedBox(height: 5),
                              CupertinoTextField(
                                controller: userDetailController,
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
                                'Set',
                                style: TextStyle(
                                    color: Colors.blue
                                ),
                              ),
                              onPressed: (){
                                HapticFeedback.lightImpact();
                                setUserStatus(userID, userDetailController.text);
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
              CupertinoActionSheetAction(
                  child: Text(userAccEnable==1 ? 'Ban user' : 'Unban user'),
                  onPressed: (){
                    HapticFeedback.lightImpact();
                    toggleUserBan(userID);
                    Navigator.of(context).pop();
                  }
              )
            ],
          );
        }
    );
  }
}

