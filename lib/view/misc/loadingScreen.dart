import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen {

  static Future<void> showLoadingScreen(BuildContext context, GlobalKey key) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
            key: key,
            child: Container(
              width: 100,
              height: 80.0,
              decoration: BoxDecoration(color: Colors.transparent),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "Loading...",
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 20),
                  CupertinoActivityIndicator(radius: 12),
                ],
              ),
            )
        );
      },
    );
  }
}