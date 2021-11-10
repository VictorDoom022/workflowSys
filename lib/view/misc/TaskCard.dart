import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/miscController.dart';

class TaskCard extends StatelessWidget {

  final String taskDate;
  final String taskMonth;
  final String title;
  final String taskCreateUserName;
  final String lastUpdatedTime;
  final String lastAssignedUserName;
  final String statusMsg;
  final String desc;
  final int color;
  final int priority;

  TaskCard({Key? key, required this.taskDate, required this.taskMonth, required this.title, required this.taskCreateUserName, required this.lastUpdatedTime, required this.lastAssignedUserName, required this.statusMsg, required this.desc, required this.color, required this.priority}) : super(key: key);

  Color setCardBorderColor(colorID){
    // taskColor docs
    // 0 = default
    // 1 = blue (primary)
    // 2 = red (danger)
    // 3 = yellow (warning)
    // 4 = green (success)
    // 5 = grey (secondary)
    // 6 = black (dark)
    List<Color> colorList = [ThemeData().cardColor, Colors.blueAccent, Colors.redAccent, Colors.yellow, Colors.greenAccent, Colors.black26, Colors.black];

    return colorList[colorID];
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Card(
        shape: Border(
          left: BorderSide(
            color: setCardBorderColor(color),
            width: 3
          )
        ),
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
                              Icons.warning_amber_rounded,
                              color: Colors.black54,
                            ),
                            SizedBox(width: 5),
                            Text(
                              convertPriorityTypeToString(priority),
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
      ),
    );
  }
}