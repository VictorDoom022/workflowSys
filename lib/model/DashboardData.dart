class DashboardData {
  DashboardData({
    required this.totalTask,
    required this.activeTaskCount,
    required this.completedTaskCount,
    required this.highPriorityTaskCount,
    required this.assignedToUserTaskCount,
    required this.recentTaskActivityData,
    required this.completedTaskHistoryData,
  });
  late final int totalTask;
  late final int activeTaskCount;
  late final int completedTaskCount;
  late final int highPriorityTaskCount;
  late final int assignedToUserTaskCount;
  late final List<RecentTaskActivityData> recentTaskActivityData;
  late final List<CompletedTaskHistoryData> completedTaskHistoryData;

  DashboardData.fromJson(Map<String, dynamic> json){
    totalTask = json['totalTask'];
    activeTaskCount = json['activeTaskCount'];
    completedTaskCount = json['completedTaskCount'];
    highPriorityTaskCount = json['highPriorityTaskCount'];
    assignedToUserTaskCount = json['assignedToUserTaskCount'];
    recentTaskActivityData = List.from(json['recentTaskActivityData']).map((e)=>RecentTaskActivityData.fromJson(e)).toList();
    completedTaskHistoryData = List.from(json['completedTaskHistoryData']).map((e)=>CompletedTaskHistoryData.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['totalTask'] = totalTask;
    _data['activeTaskCount'] = activeTaskCount;
    _data['completedTaskCount'] = completedTaskCount;
    _data['highPriorityTaskCount'] = highPriorityTaskCount;
    _data['assignedToUserTaskCount'] = assignedToUserTaskCount;
    _data['recentTaskActivityData'] = recentTaskActivityData.map((e)=>e.toJson()).toList();
    _data['completedTaskHistoryData'] = completedTaskHistoryData.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class RecentTaskActivityData {
  RecentTaskActivityData({
    required this.date,
    required this.taskCount,
  });
  late final String date;
  late final int taskCount;

  RecentTaskActivityData.fromJson(Map<String, dynamic> json){
    date = json['date'];
    taskCount = json['taskCount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['taskCount'] = taskCount;
    return _data;
  }
}

class CompletedTaskHistoryData {
  CompletedTaskHistoryData({
    required this.date,
    required this.taskCount,
  });
  late final String date;
  late final int taskCount;

  CompletedTaskHistoryData.fromJson(Map<String, dynamic> json){
    date = json['date'];
    taskCount = json['taskCount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['taskCount'] = taskCount;
    return _data;
  }
}