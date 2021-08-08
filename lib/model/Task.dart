class Task {
  int id;
  String taskTaskListID;
  String taskTeamID;
  String taskName;
  String taskDesc;
  String taskUserCreateID;
  String taskAssignedMemberID;
  String taskAssignedDate;
  String taskStartDate;
  String taskDueDate;
  String taskStatusMsg;
  int taskStatus;
  String createdAt;
  String updatedAt;

  Task(
      {this.id,
        this.taskTaskListID,
        this.taskTeamID,
        this.taskName,
        this.taskDesc,
        this.taskUserCreateID,
        this.taskAssignedMemberID,
        this.taskAssignedDate,
        this.taskStartDate,
        this.taskDueDate,
        this.taskStatusMsg,
        this.taskStatus,
        this.createdAt,
        this.updatedAt});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskTaskListID = json['task_taskListID'];
    taskTeamID = json['taskTeamID'];
    taskName = json['task_name'];
    taskDesc = json['task_desc'];
    taskUserCreateID = json['task_userCreateID'];
    taskAssignedMemberID = json['task_assignedMemberID'];
    taskAssignedDate = json['task_assignedDate'];
    taskStartDate = json['task_startDate'];
    taskDueDate = json['task_dueDate'];
    taskStatusMsg = json['task_statusMsg'];
    taskStatus = json['task_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_taskListID'] = this.taskTaskListID;
    data['taskTeamID'] = this.taskTeamID;
    data['task_name'] = this.taskName;
    data['task_desc'] = this.taskDesc;
    data['task_userCreateID'] = this.taskUserCreateID;
    data['task_assignedMemberID'] = this.taskAssignedMemberID;
    data['task_assignedDate'] = this.taskAssignedDate;
    data['task_startDate'] = this.taskStartDate;
    data['task_dueDate'] = this.taskDueDate;
    data['task_statusMsg'] = this.taskStatusMsg;
    data['task_status'] = this.taskStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}