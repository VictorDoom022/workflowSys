import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/groupController.dart';
import 'package:workflow_sys/model/GroupDetailReceiver.dart';

class groupDetail extends StatefulWidget {

  final int groupID;

  const groupDetail({Key key, this.groupID}) : super(key: key);

  @override
  _groupDetailState createState() => _groupDetailState(groupID);
}

class _groupDetailState extends State<groupDetail> {

  final int groupID;

  _groupDetailState(this.groupID);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Group'),
      ),
      body: FutureBuilder<GroupDetailReceiver>(
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
        );
      }
    );
  }
}

