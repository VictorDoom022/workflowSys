import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/teamController.dart';
import 'package:workflow_sys/model/TeamDetailReceiver.dart';

class teamDetail extends StatefulWidget {

  final int teamID;

  const teamDetail({Key key, this.teamID}) : super(key: key);

  @override
  _teamDetailState createState() => _teamDetailState(teamID);
}

class _teamDetailState extends State<teamDetail> {

  final int teamID;

  _teamDetailState(this.teamID);

  Future<TeamDetailReceiver> futureTeamDetailReceiver;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeamDetailData();
  }

  Future<void> getTeamDetailData() async {
    TeamDetailReceiver teamDetailReceiver = await getTeamDetail(teamID);
    setState(() {
      futureTeamDetailReceiver = Future.value(teamDetailReceiver);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('Team'),
      ),
      body: FutureBuilder<TeamDetailReceiver>(
        future: futureTeamDetailReceiver,
        builder: (context, snapshot){
          if(snapshot.hasError) print(snapshot.error);

          if(snapshot.hasData){
            return teamItem(teamDetailReceiver: snapshot.data);
          }else{
            return Center(child: CupertinoActivityIndicator(radius: 12));
          }
        },
      ),
    );
  }
}

class teamItem extends StatelessWidget {

  final TeamDetailReceiver teamDetailReceiver;

  const teamItem({Key key, this.teamDetailReceiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: teamDetailReceiver.taskList.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text('Task UserID: '+ teamDetailReceiver.taskList[index].taskListUserID),
        );
      },
    );
  }
}

