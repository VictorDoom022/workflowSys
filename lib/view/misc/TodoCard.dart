import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {

  final String todoDate;
  final String todoMonth;
  final String name;
  final String lastUpdatedTime;
  final String statusMsg;
  final String desc;

  const TodoCard({Key key, this.todoDate, this.todoMonth, this.name, this.lastUpdatedTime, this.statusMsg, this.desc}) : super(key: key);

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
                      todoDate,
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                  ),
                  Text(
                    todoMonth,
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
                  name,
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