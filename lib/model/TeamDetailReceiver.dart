import 'package:workflow_sys/model/Team.dart';
import 'package:workflow_sys/model/taskList.dart';

class TeamDetailReceiver {
  Team? team;
  List<TaskList?>? taskList;

  TeamDetailReceiver({this.team, this.taskList});

  TeamDetailReceiver.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    if (json['taskList'] != null) {
      taskList = <TaskList>[];
      json['taskList'].forEach((v) {
        taskList?.add(new TaskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.team != null) {
      data['team'] = this.team?.toJson();
    }
    if (this.taskList != null) {
      data['taskList'] = this.taskList?.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}