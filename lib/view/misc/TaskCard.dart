import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {

  final String taskDate;
  final String taskMonth;
  final String title;
  final String taskCreateUserName;
  final String lastUpdatedTime;
  final String lastAssignedUserName;
  final String statusMsg;
  final String desc;

  const TaskCard({Key key, this.taskDate, this.taskMonth, this.title, this.taskCreateUserName, this.lastUpdatedTime, this.lastAssignedUserName, this.statusMsg, this.desc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)
                        )
                    ),
                    child: Text(
                      taskDate,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  Text(
                    taskMonth,
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
          ),
          Expanded(
            flex: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Wrap(
                  children: [
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            taskCreateUserName,
                            style: TextStyle(
                                fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            lastUpdatedTime,
                            style: TextStyle(
                                fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.person_crop_circle_fill_badge_exclam,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 5),
                          Text(
                            lastAssignedUserName,
                            style: TextStyle(
                                fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.black54,
                          ),
                          Text(
                            statusMsg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  desc,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}