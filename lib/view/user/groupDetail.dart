import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/model/GroupDetailReceiver.dart';
import 'package:workflow_sys/view/user/teamDetail.dart';

class groupDetail extends StatefulWidget {

  final int groupID;
  final String groupName;

  const groupDetail({Key key, this.groupID, this.groupName}) : super(key: key);

  @override
  _groupDetailState createState() => _groupDetailState(groupID, groupName);
}

class _groupDetailState extends State<groupDetail> {

  final int groupID;
  final String groupName;

  _groupDetailState(this.groupID, this.groupName);

  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<GroupDetailReceiver> futureGroupDetailReceiver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupDetailData();
  }

  Future<void> getGroupDetailData() async {
    GroupDetailReceiver groupDetailReceiver = await getGroupDetail(groupID);
    setState(() {
      futureGroupDetailReceiver = Future.value(groupDetailReceiver);
    });
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('group ($groupName)'),
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        header: BezierCircleHeader(),
        onRefresh: getGroupDetailData,
        child: FutureBuilder<GroupDetailReceiver>(
          future: futureGroupDetailReceiver,
          builder: (context, snapshot){
            if(snapshot.hasError) print(snapshot.error);

            if(snapshot.hasData){
              return groupItem(groupDetailReceiver: snapshot.data);
            }else{
              return Center(child: CupertinoActivityIndicator(radius: 12));
            }
          },
        ),
      ),
    );
  }
}

class groupItem extends StatelessWidget {

  final GroupDetailReceiver groupDetailReceiver;

  const groupItem({Key key, this.groupDetailReceiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: groupDetailReceiver.team.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(groupDetailReceiver.team[index].teamName),
          onTap: (){
            HapticFeedback.lightImpact();
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder:(context){
                      return teamDetail(teamID: groupDetailReceiver.team[index].id, teamName: groupDetailReceiver.team[index].teamName);
                    }
                )
            );
          },
        );
      }
    );
  }
}

