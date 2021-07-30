import 'Group.dart';
import 'Team.dart';

class GroupDetailReceiver {
  Group group;
  List<Team> team;

  GroupDetailReceiver({this.group, this.team});

  GroupDetailReceiver.fromJson(Map<String, dynamic> json) {
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
    if (json['team'] != null) {
      team = new List<Team>();
      json['team'].forEach((v) {
        team.add(new Team.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.group != null) {
      data['group'] = this.group.toJson();
    }
    if (this.team != null) {
      data['team'] = this.team.map((v) => v.toJson()).toList();
    }
    return data;
  }
}