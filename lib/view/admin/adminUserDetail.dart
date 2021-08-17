import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_sys/controller/miscController.dart';
import 'package:workflow_sys/model/User.dart';
import 'package:workflow_sys/model/UserDetail.dart';
import 'package:workflow_sys/model/UserReceiver.dart';

class adminUserDetail extends StatefulWidget {

  final User user;
  final UserDetail userDetail;

  const adminUserDetail({Key key, this.user, this.userDetail}) : super(key: key);

  @override
  _adminUserDetailState createState() => _adminUserDetailState(user, userDetail);
}

class _adminUserDetailState extends State<adminUserDetail> {

  final User user;
  final UserDetail userDetail;

  _adminUserDetailState(this.user, this.userDetail);

  TextStyle textTitleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold
  );

  TextStyle textInfoStyle = TextStyle(
      fontSize: 20,
      fontStyle: FontStyle.italic
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('User Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CardRowItem(
                            title: 'Account ID',
                            content: user.id.toString(),
                          ),
                          CardRowItem(
                            title: 'Name',
                            content: user.name,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CardRowItem(
                            title: 'Email',
                            content: user.email,
                          ),
                          CardRowItem(
                            title: 'Create At',
                            content: convertBackendDateTime(user.createdAt),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CardRowItem(
                            title: 'Account Status',
                            content: userDetail.userDetailStatus,
                          ),
                          CardRowItem(
                            title: 'Account Enabled',
                            content: userDetail.userDetailAccEnable==1 ? 'true' : 'false',
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CardRowItem(
                            title: 'Account Type',
                            content: user.position,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardRowItem extends StatelessWidget {

  final String title;
  final String content;

  const CardRowItem({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    TextStyle titleTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
                title,
              style: titleTextStyle,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(content),
          )
        ],
      ),
    );
  }
}

