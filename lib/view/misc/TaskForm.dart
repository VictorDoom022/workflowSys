import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskFormCard extends StatelessWidget {

  final String cardTitle;
  final List<Widget> cardItemList;

  const TaskFormCard({Key key, this.cardTitle, this.cardItemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              cardTitle,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            for(var cardItem in cardItemList) cardItem
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {

  final String itemTitle;
  final Widget itemWidget;

  const TaskItem({Key key, this.itemTitle, this.itemWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(itemTitle),
        ),
        Expanded(
          flex: 9,
          child: itemWidget,
        )
      ],
    );
  }
}