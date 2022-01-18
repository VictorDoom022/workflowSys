import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskFormCard extends StatelessWidget {

  final String? cardTitle;
  final List<Widget> cardItemList;

  const TaskFormCard({Key? key, this.cardTitle = "", required this.cardItemList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            cardTitle != "" ? Text(
              cardTitle!,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ) : Container(),
            for(var cardItem in cardItemList) cardItem
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {

  final String? itemTitle;
  final Widget? itemWidget;

  const TaskItem({Key? key, this.itemTitle, this.itemWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(itemTitle!),
        ),
        Expanded(
          flex: 9,
          child: itemWidget!,
        )
      ],
    );
  }
}

class TaskFormButton extends StatelessWidget {

  final String buttonText;
  final Color buttonColor;
  final Function()? buttonFunction;

  const TaskFormButton({Key? key, required this.buttonText, required this.buttonColor, this.buttonFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: TextButton(
          child: Text(
            buttonText,
            style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: 18
            ),
          ),
          onPressed: buttonFunction,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              buttonColor
            )
          ),
        ),
      ),
    );
  }
}
