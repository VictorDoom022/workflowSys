class ToDo {
  int? id;
  int? todoUserID;
  String? todoName;
  String? todoDesc;
  String? todoStartDate;
  String? todoDueDate;
  String? todoStatusMsg;
  int? todoStatus;
  String? createdAt;
  String? updatedAt;

  ToDo(
      {this.id,
        this.todoUserID,
        this.todoName,
        this.todoDesc,
        this.todoStartDate,
        this.todoDueDate,
        this.todoStatusMsg,
        this.todoStatus,
        this.createdAt,
        this.updatedAt});

  ToDo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    todoUserID = json['todo_userID'];
    todoName = json['todo_name'];
    todoDesc = json['todo_desc'];
    todoStartDate = json['todo_startDate'];
    todoDueDate = json['todo_dueDate'];
    todoStatusMsg = json['todo_statusMsg'];
    todoStatus = json['todo_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['todo_userID'] = this.todoUserID;
    data['todo_name'] = this.todoName;
    data['todo_desc'] = this.todoDesc;
    data['todo_startDate'] = this.todoStartDate;
    data['todo_dueDate'] = this.todoDueDate;
    data['todo_statusMsg'] = this.todoStatusMsg;
    data['todo_status'] = this.todoStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
