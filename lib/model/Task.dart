class Task {
  int id;
  String taskTaskListID;
  String taskName;
  String taskDesc;
  String taskUserCreateID;
  String taskCollabUserID;
  String taskAssignedMemberID;
  String taskStartDate;
  String taskDueDate;
  String taskStatus;
  String createdAt;
  String updatedAt;

  Task(
      {this.id,
        this.taskTaskListID,
        this.taskName,
        this.taskDesc,
        this.taskUserCreateID,
        this.taskCollabUserID,
        this.taskAssignedMemberID,
        this.taskStartDate,
        this.taskDueDate,
        this.taskStatus,
        this.createdAt,
        this.updatedAt});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskTaskListID = json['task_taskListID'];
    taskName = json['task_name'];
    taskDesc = json['task_desc'];
    taskUserCreateID = json['task_userCreateID'];
    taskCollabUserID = json['task_collabUserID'];
    taskAssignedMemberID = json['task_assignedMemberID'];
    taskStartDate = json['task_startDate'];
    taskDueDate = json['task_dueDate'];
    taskStatus = json['task_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_taskListID'] = this.taskTaskListID;
    data['task_name'] = this.taskName;
    data['task_desc'] = this.taskDesc;
    data['task_userCreateID'] = this.taskUserCreateID;
    data['task_collabUserID'] = this.taskCollabUserID;
    data['task_assignedMemberID'] = this.taskAssignedMemberID;
    data['task_startDate'] = this.taskStartDate;
    data['task_dueDate'] = this.taskDueDate;
    data['task_status'] = this.taskStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}