class Comment {
  int id;
  int commentTaskID;
  int commentUserID;
  String commentDetails;
  String createdAt;
  String updatedAt;

  Comment(
      {this.id,
        this.commentTaskID,
        this.commentUserID,
        this.commentDetails,
        this.createdAt,
        this.updatedAt});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentTaskID = json['comment_taskID'];
    commentUserID = json['comment_userID'];
    commentDetails = json['comment_details'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_taskID'] = this.commentTaskID;
    data['comment_userID'] = this.commentUserID;
    data['comment_details'] = this.commentDetails;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}