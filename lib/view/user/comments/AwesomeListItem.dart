import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AwesomeListItem extends StatefulWidget {
  final bool? highlightTitle;
  final String title;
  final String content;
  final String image;

  AwesomeListItem({this.highlightTitle = false, required this.title, required this.content, required this.image});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

class _AwesomeListItemState extends State<AwesomeListItem> {

  List<Color> colorList = [
    Color(0xFFEF7A85),
    Color(0xFFFF90B3),
    Color(0xFFFFC2E2),
    Color(0xFFB892FF),
    Color(0xFFB892FF)
  ];


  @override
  Widget build(BuildContext context) {

    Color selectedRandomColor = colorList[Random().nextInt(5)];

    return new Row(
      children: <Widget>[
        new Container(width: 10.0, height: 190.0, color: selectedRandomColor),
        new Expanded(
          child: new Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.title,
                  style: TextStyle(
                      color: widget.highlightTitle! ? Color(0xfffbb448) :Colors.grey.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: new Text(
                    widget.content,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 150.0,
          width: 150.0,
          child: Stack(
            children: <Widget>[
              new Transform.translate(
                offset: new Offset(50.0, 0.0),
                child: new Container(
                  height: 100.0,
                  width: 100.0,
                  color: selectedRandomColor,
                ),
              ),
              new Transform.translate(
                offset: Offset(10.0, 20.0),
                child: new Card(
                  elevation: 20.0,
                  child: new Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 10.0,
                            color: Colors.white,
                            style: BorderStyle.solid
                        ),
                        image: DecorationImage(
                          image: NetworkImage(widget.image),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}